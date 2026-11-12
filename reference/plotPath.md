# Plot paths between resources

`plotPath` provides a visual of a graph and the selected path.

## Usage

``` r
plotPath(graph, ...)

# S4 method for class 'igraph'
plotPath(
  graph,
  by = NULL,
  k = 1,
  include = NULL,
  exclude = NULL,
  res.name = NULL,
  prune = FALSE,
  focus = FALSE,
  edge.type = "link",
  ...
)
```

## Arguments

- graph:

  An igraph object.

- ...:

  Additional arguments passed to
  [`ggraph`](https://ggraph.data-imaginist.com/reference/ggraph.html).

- by:

  A formula specifying the path to plot. (Default: `NULL`)

- k:

  `Numeric scalar`. The kth shortest path to plot. (Default: `1`)

- include:

  `Character vector`. Nodes to cross in the path. (Default: `NULL`)

- exclude:

  `Character vector`. Nodes to avoid in the path. (Default: `NULL`)

- res.name:

  `Character vector`. Names of resources to include in the graph.
  (Default: `NULL`)

- prune:

  `Logical scalar`. Whether the edges and nodes in the path should be
  plotted. (Default: `FALSE`)

- focus:

  `Logical scalar`. Whether the selected edges and nodes should be
  zoomed in. (Default: `FALSE`)

- edge.type:

  `Character scalar` String specifying the type of edge to use from the
  options available in ggraph (geom_edge\_\*). (Default: `"link"`)

## Value

A ggplot2 object.

## Examples

``` r
# Retrieve resource graph
graph <- ariadne()

# Plot graph for a subset of resources
plotPath(graph, res.name = c("KEGG", "WoL"))
#> Using "stress" as default layout


# Plot fifth path from ko to ec
plotPath(graph, ko ~ ec, k = 5)
#> Using "stress" as default layout


# Plot first path including uniref90
plotPath(graph, taxid ~ ko, include = "uniref90")
#> Using "stress" as default layout


# Plot first 5 paths excluding uniref50 and uniref100
plotPath(graph, taxid ~ ko, k = 5, exclude = "uniref50")
#> Using "stress" as default layout
```
