# Draw path steps as a reproducible table

`drawPath` creates a data.frame with the metadata on each step in the
selected path, including its origin, version and url. This can be used
to complement analysis results and ensure reproducibility.

## Usage

``` r
drawPath(graph, ...)

# S4 method for class 'igraph'
drawPath(graph, by, k = 1, include = NULL, exclude = NULL, res.name = NULL)
```

## Arguments

- graph:

  An igraph object.

- ...:

  Unused.

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

## Value

A data.frame with path steps in the rows and step metadata in the
columns.

## Examples

``` r
# Retrieve resource graph
graph <- ariadne()

# Draw fourth path from ko to ec
df <- drawPath(graph, ko ~ ec, k = 4)

# View path metadata
df
#>       from       to     source  version
#> 1       ko uniref90 ChocoPhlAn v201901b
#> 2 uniref90       ec ChocoPhlAn v201901b
#>                                                                      url
#> 1       https://zenodo.org/records/17100034/files/map_ko_uniref90.txt.gz
#> 2 https://zenodo.org/records/17100034/files/map_level4ec_uniref90.txt.gz
```
