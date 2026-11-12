# Search paths between resources

`searchPath` allows to search the first k-th shortest paths between
resources.

## Usage

``` r
searchPath(graph, ...)

# S4 method for class 'igraph'
searchPath(graph, by, k = 1, include = NULL, exclude = NULL, res.name = NULL)
```

## Arguments

- graph:

  An igraph object.

- ...:

  Unused.

- by:

  A formula specifying the path to search.

- k:

  `Numeric scalar`. The kth shortest paths to search. (Default: `1`)

- include:

  `Character vector`. Nodes to cross in the path. (Default: `NULL`)

- exclude:

  `Character vector`. Nodes to avoid in the path. (Default: `NULL`)

- res.name:

  `Character vector`. Names of resources to include in the graph.
  (Default: `NULL`)

## Value

A message.

## Examples

``` r
# Retrieve resource graph
graph <- ariadne()

# Search first 5 paths from ko to ec
searchPath(graph, ko ~ ec, k = 5)
#> Path 1:
#> ko -(KEGG)-> ec
#> 
#> Path 2:
#> ko -(ChocoPhlAn)-> uniref90 -(UniProt)-> ec
#> 
#> Path 3:
#> ko -(ChocoPhlAn)-> uniref50 -(UniProt)-> ec
#> 
#> Path 4:
#> ko -(ChocoPhlAn)-> uniref90 -(ChocoPhlAn)-> ec
#> 
#> Path 5:
#> ko -(ChocoPhlAn)-> uniref50 -(ChocoPhlAn)-> ec
#> 

# Search first path including uniref90
searchPath(graph, taxid ~ ko, include = "uniref90")
#> Path 1:
#> taxid -(UniProt)-> uniref90 -(ChocoPhlAn)-> ko
#> 

# Search first 5 paths excluding uniref50 and uniref100
searchPath(graph, taxid ~ ko, k = 5, exclude = "uniref50")
#> Path 1:
#> taxid -(UniProt)-> uniref90 -(ChocoPhlAn)-> ko
#> 
#> Path 2:
#> taxid -(UniProt)-> uniref90 -(UniProt)-> ec -(KEGG)-> ko
#> 
#> Path 3:
#> taxid -(WoL)-> wol -(WoL)-> uniref90 -(ChocoPhlAn)-> ko
#> 
#> Path 4:
#> taxid -(UniProt)-> uniref90 -(ChocoPhlAn)-> ec -(KEGG)-> ko
#> 
#> Path 5:
#> taxid -(UniProt)-> uniref100 -(UniProt)-> ec -(KEGG)-> ko
#> 

# Search path for a subset of resources
searchPath(graph, uniref90 ~ eggnog, k = 3, res.name = "ChocoPhlAn")
#> Path 1:
#> uniref90 -(ChocoPhlAn)-> eggnog
#> 
#> Path 2:
#> uniref90 -(ChocoPhlAn)-> uniref50 -(ChocoPhlAn)-> eggnog
#> 
#> Path 3:
#> uniref90 -(ChocoPhlAn)-> pfam -(ChocoPhlAn)-> uniref50 -(ChocoPhlAn)-> eggnog
#> 
```
