#' Visualise sets network
#' 
#' @name plotSets
#' 
#' @description
#' \code{plotSets} generates a graph linking origin to target features.
#' 
#' @param sets \code{data.frame}. A linkmap as returned by
#'   \code{\link{weavePath}} or \code{\link{weaveComplex}}. Its first and second
#'   columns must contain elements to match to \code{key} and the target
#'   sets, respectively.
#' 
#' @param show.labels \code{Logical scalar}. Whether node labels should be
#'   shown. (Default: \code{TRUE})
#' 
#' @param edge.type \code{Character scalar} String specifying the type of edge
#'   to use from the options available in ggraph (geom_edge_*).
#'   (Default: \code{"diagonal"})
#' 
#' @param ... Additional arguments passed to \code{\link[ggraph:ggraph]{ggraph}}.
#' 
#' @returns A ggplot2 object.
#' 
#' @examples
#' library(ggplot2)
#' 
#' graph <- ariadne()
#' ec2gmm <- weaveComplex(graph, ec ~ gmm)
#' 
#' plotSets(ec2gmm) + coord_flip()
NULL

#' @export
#' @rdname plotSets
#' @importFrom data.table as.data.table melt
#' @importFrom igraph graph_from_data_frame
#' @importFrom ggraph ggraph scale_edge_colour_gradient2 geom_node_text
#' @importFrom ggplot2 scale_colour_manual guides guide_legend
setMethod("plotSets", signature = c(sets = "data.frame"),
    function(sets, edge.type = "diagonal", show.labels = TRUE, ...){
    
    sets <- as.data.table(sets)
    if( !"cov" %in% colnames(sets) ) sets$cov <- 1
    
    node_df <- melt(
        sets[ , c(1, 2)], measure.vars = c(1, 2),
        variable.name = "type", value.name = "name",
        variable.factor = TRUE, value.factor = TRUE
    )
    
    node_df <- unique(node_df[ , c(2, 1)])
    graph <- graph_from_data_frame(sets, vertices = node_df)
    
    geom_edge <- eval(parse(text = paste0("ggraph::geom_edge_", edge.type)))
    
    p <- ggraph(graph, ...) +
        geom_edge(aes(colour = .data$cov)) +
        geom_node_point(aes(colour = .data$type)) +
        scale_colour_manual(values = c("darkorange", "#06B4B4")) +
        scale_edge_colour_gradient2(
            low = "white", mid = "grey80", high = "red",
            midpoint = 0.5, limits = c(0, 1)
        ) +
        theme_void() +
        guides(
            colour = guide_legend(order = 1),
            edge_colour = guide_legend(order = 2)
        )
    
    if( show.labels ){
        p <- p + geom_node_text(aes(label = .data$name), vjust = 1.8, size = 2)
    }
    
    return(p)
})
