
#' @importFrom BiocFileCache bfcquery
#' @importFrom arrow write_parquet
#' @importFrom stringi stri_c stri_replace_first_fixed stri_replace_first_regex
.cache_resource <- function(url, res.name, from, to){
    # Initialise cache
    bfc <- .init_cache()
    # Build resource name
    rname <- file.path(res.name, paste(from, to, sep = "2"))
    # Check if preprocessed file is cached
    cached <- bfcquery(bfc, rname)$rpath
    # Return preprocessed file if available
    if( length(cached) > 0L ) return(cached[1])
    # Select function based on resource
    FUN <- switch(
        res.name,
        ChocoPhlAn = function(x) .process_one2many(x,
            key.FUN = ifelse(from == "go",
                function(keys) stri_replace_first_fixed(keys, "GO:", ""),
                identity)
        ),
        WoL = function(x){
            if( from == "wol" && to != "protein" ){
                
                is_uniref <- to == "uniref90"
                
                .process_one2one(x, select = c(1L, 2L), header = !is_uniref,
                    key.FUN = function(keys) stri_replace_first_regex(keys, "_.*", ""),
                    val.FUN = ifelse(is_uniref,
                        function(vals) stri_c("UniRef90_", vals), identity))
            }else{
                .process_one2many(x,
                    key.FUN = switch(from,
                        wol = function(keys) stri_replace_first_regex(keys, "_.*", ""),
                        uniref90 = function(keys) stri_c("UniRef90_", keys),
                        identity),
                    val.FUN = ifelse(to == "ec",
                        function(vals) stri_replace_first_fixed(vals, "EC-", ""),
                        identity))
            }
        },
        BugSigDB = function(x){
            is_name <- to == "bugsigdb_name"
            val.cols <- if( is_name ) 1L else -c(1L, 2L)
            
           .process_one2many(x, val.cols = val.cols, skip = 1L,
               key.FUN = function(keys){
                   # Remove module prefix and description
                   keys <- keys |>
                       stri_replace_first_fixed("bsdb:", "") |>
                       stri_replace_first_regex("_.*$", "")},
               val.FUN = ifelse(is_name,
                   function(vals) stri_replace_first_regex(vals, "^.+:", ""),
                   identity))
        },
        TIGRFAMs = function(x) .process_one2one(
            x, header = FALSE, select = c(1L, 2L),
            val.FUN = ifelse(from == "GO",
                function(vals) stri_replace_first_fixed(vals, "GO:", ""),
                identity)
        ),
        GO = function(x) .process_one2one(x, header = FALSE,
            key.FUN = function(keys) {
                keys <- keys |>
                    stri_replace_first_regex(" >.*", "") |>
                    stri_replace_first_regex("^[^:]*:", "")
            },
            val.FUN = function(vals) {
                vals <- stri_replace_first_regex(vals, "^[^:]*:", "")
            }
        ),
        GM = ifelse(to == "ko", .process_complex_modules,
            function(x) .process_one2one(x, header = FALSE)
        ),
        MSigDB = .process_rdslist
    )
    # Preprocess data
    linkmap <- FUN(url)
    # Add colnames
    if( res.name != "MSigDB" ) colnames(linkmap) <- c(from, to)
    # Store linkmap in cache as parquet file
    .add2cache(linkmap, rname, bfc)
    # Return path to cached preprocessed file
    cached <- bfcquery(bfc, rname)$rpath
    return(cached)
}


#' @importFrom BiocFileCache BiocFileCache
#' @importFrom tools R_user_dir
.init_cache <- function(){
    # Define cache dir
    cache <- R_user_dir("ariadne", "cache")
    # Initialise cache
    bfc <- BiocFileCache(cache, ask = FALSE)
    return(bfc)
}


#' @importFrom arrow write_parquet
#' @importFrom BiocFileCache bfcadd
.add2cache <- function(x, rname, bfc){
    # Find path for cache subdir
    fpath <- .init_fpath(bfc, rname)
    # Store preprocessed data
    write_parquet(x, fpath)
    # Cache the preprocessed file using URL as resource name
    bfcadd(
        bfc, rname = rname, fpath = fpath, fname = "exact", action = "asis"
    )
}


#' @importFrom BiocFileCache bfccache
.init_fpath <- function(bfc, rname){
    # Find path for cache subdir
    fpath <- bfc |>
        bfccache() |>
        file.path(rname)
    # Define resource subdir of cache dir
    subdir <- dirname(fpath)
    # Create subdir if absent
    if( !dir.exists(subdir) ) dir.create(subdir, recursive = TRUE)
    return(fpath)
}


#' @importFrom data.table fread `:=`
.process_one2one <- function(x, key.FUN = identity, val.FUN = identity, ...){
    # Read linkmap
    linkmap <- fread(x, ...)
    # Check linkmap
    if( ncol(linkmap) != 2L ){
        stop(".process_one2one received a table with a number of columns ",
            "not equal to two.", call. = FALSE)
    }
    # Add temporary colnames
    colnames(linkmap) <- c("x", "y")
    # Process keys with custom function
    linkmap[ , x := key.FUN(x)]
    # Process values with custom function
    linkmap[ , y := val.FUN(y)]
    return(linkmap)
}


#' @importFrom readr read_lines
#' @importFrom stringi stri_split_fixed
#' @importFrom data.table data.table `:=`
.process_one2many <- function(x, key.col = 1L, val.cols = -key.col,
    key.FUN = identity, val.FUN = identity, ...){
    # Preprocess file
    line_content <- x |>
        # Read file content
        read_lines(...) |>
        # Split elements in each line by tab
        stri_split_fixed("\t")
    # Extract keys
    keys <- vapply(line_content, `[`, key.col, FUN.VALUE = character(1L))
    # Extract values
    values <- lapply(line_content, `[`, val.cols)
    # Apply custom processing function to keys
    keys <- key.FUN(keys)
    # Create linkmap
    linkmap <- data.table(
        x = rep(keys, lengths(values, use.names = FALSE)),
        y = unlist(values, recursive = TRUE, use.names = FALSE)
    )
    # Apply custom processing function to values
    linkmap[ , y := val.FUN(y)]
    return(linkmap)
}


#' @importFrom httr2 request req_perform
#' @importFrom BiocParallel bplapply
#' @importFrom data.table rbindlist
#' @importFrom stringi stri_subset
#' @importFrom utils unzip
.process_rdslist <- function(x){
    # Prepare temporary file and directory
    temp_file <- tempfile(fileext = ".zip")
    temp_dir <- tempfile("dir")
    # Download file archive from Zenodo resource
    x |>
        request() |>
        req_perform(temp_file)
    # Unzip Zenodo record
    unzip(temp_file, exdir = temp_dir)
    # List files from zipped file
    files <- list.files(temp_dir, full.names = TRUE)
    # Unzip file if compressed
    if( length(files) == 1L && endsWith(files, ".zip") ){
        unzip(files, exdir = temp_dir)
    }
    # List relevant unzipped files
    files <- temp_dir |>
        list.files(full.names = TRUE) |>
        stri_subset("zip|summary", negate = TRUE)
    # Import and bind linkmaps
    linkmaps <- bplapply(files, readRDS)
    linkmap <- rbindlist(linkmaps)
    # Remove temporary file and directory
    unlink(c(temp_file, temp_dir), recursive = TRUE)
    return(linkmap)
}
