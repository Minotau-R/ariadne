# Append linkmaps to SummarizedExperiment side information

getSets and addSets allow to retrieve or append a linkmap to the side
information of a SummarizedExperiment (SE) object. This makes ariadne
interoperable with SE-based data analysis.

## Usage

``` r
getSets(x, ...)

addSets(x, ...)

# S4 method for class 'SummarizedExperiment'
addSets(
  x,
  sets,
  by = "rows",
  key = "row.names",
  names = FALSE,
  x.names = names,
  y.names = names
)

# S4 method for class 'SummarizedExperiment'
getSets(
  x,
  sets,
  by = "rows",
  key = "row.names",
  names = FALSE,
  x.names = names,
  y.names = names
)
```

## Arguments

- x:

  The rowData or colData of a
  [`SummarizedExperiment`](https://rdrr.io/pkg/SummarizedExperiment/man/SummarizedExperiment-class.html)
  object.

- ...:

  Unused.

- sets:

  `data.frame`. A linkmap as returned by
  [`weavePath`](https://minotau-r.github.io/ariadne/reference/weavePath.md)
  or
  [`weaveComplex`](https://minotau-r.github.io/ariadne/reference/weavePath.md).
  Its first and second columns must contain elements to match to `key`
  and the target sets, respectively.

- by:

  `Character scalar` A string indicating whether to append `sets` to the
  `"rows"` or `"cols"` side information of `x`. (Default: `"rows"`)

- key:

  `Character vector` A vector specifying one or more variables of `x`
  side information based on which `sets` should be appended. (Default:
  `"row.names"`)

- names:

  `Logical scalar` Should feature names instead of ids be used. When
  `TRUE`, name columns must exist in `sets`. (Default: `FALSE`)

- x.names:

  `Logical scalar` Should names instead of ids be used for the origin
  features. When `TRUE`, the origin name column must exist in `sets`.
  (Default: same as `names`)

- y.names:

  `Logical scalar` Should names instead of ids be used for the target
  features. When `TRUE`, the feature name column must exist in `sets`.
  (Default: same as `names`)

## Value

An object of the same type as `x` with additional columns in its side
information, each containing information on membership to a certain set.

## Examples

``` r
library(mia)
#> Loading required package: MultiAssayExperiment
#> Loading required package: SummarizedExperiment
#> Loading required package: MatrixGenerics
#> Loading required package: matrixStats
#> 
#> Attaching package: ‘MatrixGenerics’
#> The following objects are masked from ‘package:matrixStats’:
#> 
#>     colAlls, colAnyNAs, colAnys, colAvgsPerRowSet, colCollapse,
#>     colCounts, colCummaxs, colCummins, colCumprods, colCumsums,
#>     colDiffs, colIQRDiffs, colIQRs, colLogSumExps, colMadDiffs,
#>     colMads, colMaxs, colMeans2, colMedians, colMins, colOrderStats,
#>     colProds, colQuantiles, colRanges, colRanks, colSdDiffs, colSds,
#>     colSums2, colTabulates, colVarDiffs, colVars, colWeightedMads,
#>     colWeightedMeans, colWeightedMedians, colWeightedSds,
#>     colWeightedVars, rowAlls, rowAnyNAs, rowAnys, rowAvgsPerColSet,
#>     rowCollapse, rowCounts, rowCummaxs, rowCummins, rowCumprods,
#>     rowCumsums, rowDiffs, rowIQRDiffs, rowIQRs, rowLogSumExps,
#>     rowMadDiffs, rowMads, rowMaxs, rowMeans2, rowMedians, rowMins,
#>     rowOrderStats, rowProds, rowQuantiles, rowRanges, rowRanks,
#>     rowSdDiffs, rowSds, rowSums2, rowTabulates, rowVarDiffs, rowVars,
#>     rowWeightedMads, rowWeightedMeans, rowWeightedMedians,
#>     rowWeightedSds, rowWeightedVars
#> Loading required package: GenomicRanges
#> Loading required package: stats4
#> Loading required package: BiocGenerics
#> Loading required package: generics
#> 
#> Attaching package: ‘generics’
#> The following objects are masked from ‘package:igraph’:
#> 
#>     components, union
#> The following objects are masked from ‘package:base’:
#> 
#>     as.difftime, as.factor, as.ordered, intersect, is.element, setdiff,
#>     setequal, union
#> 
#> Attaching package: ‘BiocGenerics’
#> The following objects are masked from ‘package:igraph’:
#> 
#>     normalize, path
#> The following objects are masked from ‘package:stats’:
#> 
#>     IQR, mad, sd, var, xtabs
#> The following object is masked from ‘package:utils’:
#> 
#>     data
#> The following objects are masked from ‘package:base’:
#> 
#>     Filter, Find, Map, Position, Reduce, anyDuplicated, aperm, append,
#>     as.data.frame, basename, cbind, colnames, dirname, do.call,
#>     duplicated, eval, evalq, get, grep, grepl, is.unsorted, lapply,
#>     mapply, match, mget, order, paste, pmax, pmax.int, pmin, pmin.int,
#>     rank, rbind, rownames, sapply, saveRDS, scale, sequence, table,
#>     tapply, transform, unique, unsplit, which.max, which.min
#> Loading required package: S4Vectors
#> 
#> Attaching package: ‘S4Vectors’
#> The following object is masked from ‘package:utils’:
#> 
#>     findMatches
#> The following objects are masked from ‘package:base’:
#> 
#>     I, expand.grid, unname
#> Loading required package: IRanges
#> Loading required package: Seqinfo
#> Loading required package: Biobase
#> Welcome to Bioconductor
#> 
#>     Vignettes contain introductory material; view with
#>     'browseVignettes()'. To cite Bioconductor, see
#>     'citation("Biobase")', and for packages 'citation("pkgname")'.
#> 
#> Attaching package: ‘Biobase’
#> The following object is masked from ‘package:MatrixGenerics’:
#> 
#>     rowMedians
#> The following objects are masked from ‘package:matrixStats’:
#> 
#>     anyMissing, rowMedians
#> Loading required package: SingleCellExperiment
#> Loading required package: TreeSummarizedExperiment
#> Loading required package: Biostrings
#> Loading required package: XVector
#> 
#> Attaching package: ‘Biostrings’
#> The following object is masked from ‘package:base’:
#> 
#>     strsplit
#> This is mia version 1.21.14
#> - Online documentation and vignettes: https://microbiome.github.io/mia/
#> - Online book 'Orchestrating Microbiome Analysis (OMA)': https://bioconductor.org/books/release/OMA/
library(miaViz)
#> 
#> Attaching package: ‘miaViz’
#> The following object is masked from ‘package:mia’:
#> 
#>     plotNMDS

# Import datasets
data("Tengeler2020", package = "mia")
data("butyrate", package = "ariadne")

# Rename experiment object
tse <- Tengeler2020

# Get butyrate-producer set membership
sets <- getSets(tse, butyrate, key = "Genus", x.names = TRUE)

# Get sets based on multiple variables given in order of priority
sets <- getSets(tse, butyrate, key = c("Genus", "Family"), x.names = TRUE)

# Add sets to experiment as names instead of ids
tse <- addSets(tse, butyrate, key = "Genus", names = TRUE)

# Generate relative abundance table
tse <- transformAssay(tse, method = "relabundance")

# Agglomerate features by membership to butyrate-producer set
set.se <- agglomerateByModule(tse, by = "rows", group = "Butanoic acid")

# Plot relative abundance of butyrate producers
plotAbundance(set.se, assay.type = "relabundance")
#> Warning: Removed 2 rows containing missing values or values outside the scale range
#> (`geom_bar()`).
```
