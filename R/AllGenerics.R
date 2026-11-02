
setOldClass("igraph")

#' @export
#' @rdname searchPath
setGeneric("searchPath", signature = c("graph"), function(graph, ...)
    standardGeneric("searchPath"))

#' @export
#' @rdname plotPath
setGeneric("plotPath", signature = c("graph"), function(graph, ...)
    standardGeneric("plotPath"))

#' @export
#' @rdname drawPath
setGeneric("drawPath", signature = c("graph"), function(graph, ...)
    standardGeneric("drawPath"))

#' @export
#' @rdname linkNames
setGeneric("linkNames", signature = c("graph"), function(graph, ...)
    standardGeneric("linkNames"))

#' @export
#' @rdname addResource
setGeneric("addResource", signature = c("graph"), function(graph, ...)
    standardGeneric("addResource"))

#' @export
#' @rdname weavePath
setGeneric("weavePath", signature = c("graph"), function(graph, ...)
    standardGeneric("weavePath"))

#' @export
#' @rdname weavePath
setGeneric("weaveComplex", signature = c("graph"), function(graph, ...)
    standardGeneric("weaveComplex"))

#' @export
#' @rdname addSets
setGeneric("getSets", signature = c("x"), function(x, ...)
    standardGeneric("getSets"))

#' @export
#' @rdname addSets
setGeneric("addSets", signature = c("x"), function(x, ...)
    standardGeneric("addSets"))

#' @export
#' @rdname plotSets
setGeneric("plotSets", signature = c("sets"), function(sets, ...)
    standardGeneric("plotSets"))
