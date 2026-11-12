# Link ids to names and vice versa

`linkNames` retrieves the corresponding names for a set of ids and vice
versa. It can be used to link feature names to ids that can be directly
passed to `weavePath` and `weaveComplex`.

## Usage

``` r
linkNames(graph, ...)

# S4 method for class 'igraph'
linkNames(graph, x, ids = NULL, names = NULL, verbose = TRUE)
```

## Arguments

- graph:

  An igraph object.

- ...:

  Unused.

- x:

  `Character scalar`. A feature type present as a node in `graph`.

- ids:

  `Character vector`. A set of ids to link to their corresponding names.
  (Default: `NULL`)

- names:

  `Character vector`. A set of names to link to their corresponding ids.
  (Default: `NULL`)

- verbose:

  `Logical scalar`. Should messages be printed in the console. (Default:
  `TRUE`)

## Value

A
[`linkmap`](https://minotau-r.github.io/multifactor/reference/linkmap-class.html)
with ids and names in the first and second column, respectively.

## Examples

``` r
# Retrieve resource graph
graph <- ariadne()

# Fetch names for all Gut Metabolic modules
linkNames(graph, "gmm")
#>         gmm                           gmm.name
#>      <fctr>                             <fctr>
#>   1: MF0001           arabinoxylan degradation
#>   2: MF0002                fructan degradation
#>   3: MF0003               pectin degradation I
#>   4: MF0004             pectine degradation II
#>   5: MF0005                 starch degradation
#>  ---                                          
#>  99: MF0099        methanogenesis - methyl-coM
#> 100: MF0100 methanogenesis from carbon dioxide
#> 101: MF0101  nitrate reduction (dissimilatory)
#> 102: MF0102  sulfate reduction (dissimilatory)
#> 103: MF0103                  mucin degradation

# Fetch names for a set of KO ids
linkNames(graph, "ko", ids = c("K00001", "K00844", "K03455"))
#>       ko                             ko.name
#> 1 K00001  alcohol dehydrogenase [EC:1.1.1.1]
#> 2 K00844             hexokinase [EC:2.7.1.1]
#> 3 K03455                    K+:H+ antiporter

# Fetch names for a set of EC names
linkNames(graph, "ec", names = c("alcohol dehydrogenase", "alditol oxidase"))
#>         ec               ec.name
#> 1  1.1.1.1 alcohol dehydrogenase
#> 2 1.1.3.41       alditol oxidase
```
