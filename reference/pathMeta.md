# Data frame for pathway from chebi to gmm

`pathMeta` provides a minimal example of a data frame describing one
pathway in the ariadne graph from chebi to gmm. This kind of data frame
is typically the output of
[`drawPath`](https://minotau-r.github.io/ariadne/reference/drawPath.md)
and works as input for
[`weavePath`](https://minotau-r.github.io/ariadne/reference/weavePath.md)
and
[`weaveComplex`](https://minotau-r.github.io/ariadne/reference/weavePath.md).

## Value

A pathway data frame with four rows (steps) and four columns (from, to,
source and version).

## Examples

``` r
# Import data frame for pathway from chebi to gmm
data("pathMeta", package = "ariadne")

# Print pathway data frame
pathMeta
#>    from   to source version
#> 1 chebi rhea   Rhea  latest
#> 2  rhea   ec   Rhea  latest
#> 3    ec   ko   KEGG  latest
#> 4    ko  gmm     GM      v1
#>                                                                                     url
#> 1                                                                                  <NA>
#> 2                                                                                  <NA>
#> 3                                                                                  <NA>
#> 4 https://github.com/omixer/omixer-rpmR/raw/refs/heads/main/inst/extdata/GMMs.v1.07.txt

# Recreate pathMeta using ariadne
# graph <- ariadne()
# pathMeta <- drawPath(graph, chebi ~ gmm, include = "rhea")
```
