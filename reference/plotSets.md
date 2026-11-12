# Visualise sets network

`plotSets` generates a graph linking origin to target features.

## Usage

``` r
plotSets(sets, ...)

# S4 method for class 'data.frame'
plotSets(sets, edge.type = "diagonal", show.labels = TRUE, ...)
```

## Arguments

- sets:

  `data.frame`. A linkmap as returned by
  [`weavePath`](https://minotau-r.github.io/ariadne/reference/weavePath.md)
  or
  [`weaveComplex`](https://minotau-r.github.io/ariadne/reference/weavePath.md).
  Its first and second columns must contain elements to match to `key`
  and the target sets, respectively.

- ...:

  Additional arguments passed to
  [`ggraph`](https://ggraph.data-imaginist.com/reference/ggraph.html).

- edge.type:

  `Character scalar` String specifying the type of edge to use from the
  options available in ggraph (geom_edge\_\*). (Default: `"diagonal"`)

- show.labels:

  `Logical scalar`. Whether node labels should be shown. (Default:
  `TRUE`)

## Value

A ggplot2 object.

## Examples

``` r
library(ggplot2)

graph <- ariadne()
ec2gmm <- weaveComplex(graph, ec ~ gmm)
#> ec -(KEGG)-> ko
#> ko -(GM)-> gmm

plotSets(ec2gmm) + coord_flip()
#> Using "sugiyama" as default layout
```
