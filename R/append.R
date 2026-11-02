#' Append linkmaps to SummarizedExperiment side information
#' 
#' @name addSets
#' 
#' @description
#' getSets and addSets allow to retrieve or append a linkmap to the side
#' information of a SummarizedExperiment (SE) object. This makes ariadne
#' interoperable with SE-based data analysis.
#' 
#' @param x The rowData or colData of a
#'   \code{\link[SummarizedExperiment:SummarizedExperiment-class]{SummarizedExperiment}}
#'   object.
#' 
#' @param sets \code{data.frame}. A linkmap as returned by
#'   \code{\link{weavePath}} or \code{\link{weaveComplex}}. Its first and second
#'   columns must contain elements to match to \code{key} and the target
#'   sets, respectively. 
#' 
#' @param by \code{Character scalar} A string indicating whether to append
#'   \code{sets} to the \code{"rows"} or \code{"cols"} side information of
#'   \code{x}. (Default: \code{"rows"})
#' 
#' @param key \code{Character vector} A vector specifying one or more variables
#'   of \code{x} side information based on which \code{sets} should be
#'   appended. (Default: \code{"row.names"})
#' 
#' @param names \code{Logical scalar} Should feature names instead of ids be
#'   used. When \code{TRUE}, name columns must exist in \code{sets}.
#'   (Default: \code{FALSE})
#' 
#' @param x.names \code{Logical scalar} Should names instead of ids be used for
#'   the origin features. When \code{TRUE}, the origin name column must exist in
#'   \code{sets}. (Default: same as \code{names})
#' 
#' @param y.names \code{Logical scalar} Should names instead of ids be used for
#'   the target features. When \code{TRUE}, the feature name column must exist
#'   in \code{sets}. (Default: same as \code{names})
#' 
#' @param ... Unused.
#' 
#' @returns
#' An object of the same type as \code{x} with additional columns in its side
#' information, each containing information on membership to a certain set.
#' 
#' @examples
#' library(mia)
#' library(miaViz)
#' 
#' # Import datasets
#' data("Tengeler2020", package = "mia")
#' data("butyrate", package = "ariadne")
#' 
#' # Rename experiment object
#' tse <- Tengeler2020
#' 
#' # Get butyrate-producer set membership
#' sets <- getSets(tse, butyrate, key = "Genus", x.names = TRUE)
#' 
#' # Get sets based on multiple variables given in order of priority
#' sets <- getSets(tse, butyrate, key = c("Genus", "Family"), x.names = TRUE)
#' 
#' # Add sets to experiment as names instead of ids
#' tse <- addSets(tse, butyrate, key = "Genus", names = TRUE)
#' 
#' # Generate relative abundance table
#' tse <- transformAssay(tse, method = "relabundance")
#' 
#' # Agglomerate features by membership to butyrate-producer set
#' set.se <- agglomerateByModule(tse, by = "rows", group = "butyrate")
#' 
#' # Plot relative abundance of butyrate producers
#' plotAbundance(set.se, assay.type = "relabundance")
NULL


#' @export
#' @rdname addSets
#' @importFrom SummarizedExperiment rowData rowData<- colData colData<-
setMethod("addSets", signature = c(x = "SummarizedExperiment"),
    function(x, sets, by = "rows", key = "row.names", names = FALSE,
    x.names = names, y.names = names){
    # Check margin
    if( length(by) == 0L || !by %in% c("rows", "cols") ){
        stop("'by' must be either 'rows' or 'cols'.", call. = FALSE)
    }
    # Select side information based on margin
    df <- if( by == "rows" ) rowData(x) else colData(x)
    # Build sets table
    sets <- .get_sets(df, sets, key, x.names, y.names)
    # Find any duplicate columns
    to_remove <- which(colnames(df) %in% colnames(sets))
    # Replace duplicate columns
    if( length(to_remove) != 0L ){
        warning("Some columns were replaced.", call. = FALSE)
        df[to_remove] <- NULL
    }
    # Append sets to side information
    out <- cbind(df, sets)
    if( by == "rows" ) rowData(x) <- out else colData(x) <- out
    return(x)
})


#' @export
#' @rdname addSets
#' @importFrom SummarizedExperiment rowData colData
setMethod("getSets", signature = c(x = "SummarizedExperiment"),
    function(x, sets, by = "rows", key = "row.names", names = FALSE,
    x.names = names, y.names = names){
    # Check margin
    if( length(by) == 0L || !by %in% c("rows", "cols") ){
        stop("'by' must be either 'rows' or 'cols'.", call. = FALSE)
    }
    # Select side information based on margin
    df <- if( by == "rows" ) rowData(x) else colData(x)
    # Build sets table
    out <- .get_sets(df, sets, key, x.names, y.names)
    # Convert to dataframe
    out <- as.data.frame(out)
    # Add tidy rownames
    rownames(out) <- rownames(df)
    return(out)
})


#' @importFrom stats reformulate
#' @importFrom data.table set dcast as.data.table
.get_sets <- function(df, sets, key, x.names, y.names){
    # Check if by is rownames
    is_rownames <- length(key) == 1L && key == "row.names"
    # Check args
    if( !is_rownames && !all(key %in% colnames(df)) ){
        stop("'key' must be 'row.names' or a variable of 'x'.", call. = FALSE)
    }
    if( length(x.names) != 1L || !is.logical(x.names) || is.na(x.names) ){
        stop("'x.names' must be TRUE or FALSE.", call. = FALSE)
    }
    if( length(y.names) != 1L || !is.logical(y.names) || is.na(y.names) ){
        stop("'y.names' must be TRUE or FALSE.", call. = FALSE)
    }
    # Choose between ids and names
    origin_col <- colnames(sets)[1L]
    if( x.names ) origin_col <- paste0(origin_col, ".name")
    target_col <- colnames(sets)[2L]
    if( y.names ) target_col <- paste0(target_col, ".name")
    # Create formula for dcast
    widen_form <- reformulate(target_col, origin_col)
    # Convert sets to data.table
    sets <- as.data.table(sets)
    # Add cov variable if absent
    if( !"cov" %in% colnames(sets) ) sets$cov <- 1
    # Widen sets
    sets <- dcast(sets, widen_form, value.var = "cov", fill = 0)
    # Match by rownames
    if( is_rownames ){
        idx <- match(rownames(df), sets[[origin_col]])
    # Match by one variable
    }else if( length(key) == 1L ){
        idx <- match(df[[key]], sets[[origin_col]])
    # Match by multiple variables (decreasing priority)
    }else{
        idx <- apply(df[key], 1L, function(row){
            m <- match(row, sets[[origin_col]])
            first_match <- m[!is.na(m)][1L]
        })
    }
    # Select and order matched sets rows
    out <- sets[idx, -1L]
    # Replace missing values with 0
    for( col in colnames(out) ){
        set(out, which(is.na(out[[col]])), col, 0)
    }
    return(out)
}
