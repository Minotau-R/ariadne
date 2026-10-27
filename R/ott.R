
#' @importFrom stats na.omit
#' @importFrom stringr str_remove
#' @importFrom BiocParallel bplapply
.queryOTT <- function(from, to, init, timeout, flip = FALSE, ...){
    # Unfactorise init
    if( is.factor(init) ) init <- as.character(init)
    # Invert features if flipped
    if( flip ){
        tmp <- to
        to <- from
        from <- tmp
    }
    # If source is taxname
    if( from == "name" ){
        # Search with TNRS API
        y <- .queryTNRS(init, to, ...)
    }
    # If source is ott
    else if( from == "ott" ){
        # Convert to numeric
        x <- as.numeric(init)
        # Search with taxon_info API
        y <- bplapply(
            x, .queryTaxonInfo, to = to, prefix = "ott_id", timeout = timeout
        )
    # If source is external taxon id
    }else if( from %in% c("ncbi", "gbif", "worms", "if", "irmng") ){
        # Add prefix
        x <- paste0(from, ":", init)
        # Search with taxon_info API
        y <- bplapply(
            x, .queryTaxonInfo, to = to, prefix = "source_id", timeout = timeout
        )
    }else{
        stop("'from' is not valid.", call. = FALSE)
    }
    # Fill empty results
    y[lengths(y) == 0L] <- NA
    # Create linkmap
    linkmap <- data.frame(
        x = rep(init, lengths(y, use.names = FALSE)),
        y = unlist(y, recursive = TRUE, use.names = FALSE)
    )
    # Omit rows with missing values
    linkmap <- na.omit(linkmap)
    # Strip source prefix
    linkmap$y <- str_remove(linkmap$y, "^.+:")
    # Revert columns if flipped
    if( flip ) linkmap <- rev(linkmap)
    return(linkmap)
}


#' @importFrom stringr str_subset fixed
#' @importFrom httr2 request req_method req_body_json req_perform resp_body_json
.queryTaxonInfo <- function(x, to, prefix, timeout){
    
    url <- "https://api.opentreeoflife.org/v3/taxonomy/taxon_info"
    
    body <- list()
    body[[prefix]] <- x
    
    resp <- request(url) |>
        req_method("POST") |>
        req_body_json(body) |>
        req_timeout(timeout) |>
        req_perform()
    
    resp <- resp_body_json(resp)
    
    # Handle missing or empty responses
    if( is.null(resp) || length(resp) == 0L ){
        return(NA_character_)
    }
    
    if( to == "ott" ){
        y <- resp$ott_id
    }else if( to == "name" ){
        y <- resp$unique_name
    }else{
        tax_sources <- unlist(resp$tax_sources)
        y <- str_subset(tax_sources, fixed(to))
    }
    return(y)
}

#' @importFrom BiocParallel bplapply
.queryTNRS <- function(x, to, batch.size = 1000, workers = NULL, factor = 3){
    
    ranges <- .get_batches(x, batch.size, workers, factor)
    
    out.list <- bplapply(
       ranges, function(i) .subqueryTNRS(x[i[1]:i[2]], to = to)
    )
    
    out <- do.call(c, out.list)
    return(out)
}


#' @importFrom rotl tnrs_match_names tax_sources
#' @importFrom stringr str_subset fixed
.subqueryTNRS <- function(x, to){
    # Match input names
    res <- tnrs_match_names(x)
    # Based on target
    if( to == "ott" ){
        # Extract ott ids
        y <- res$ott_id
    }else{
        # Find ids for each input
        y <- lapply(tax_sources(res), str_subset, pattern = fixed(to))
        # Match ids to input names
        y <- y[res$unique_name]
    }
    return(y)
}
