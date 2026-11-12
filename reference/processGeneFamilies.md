# Process HUMAnN gene families

processGeneFamilies prepares a SummarizedExperiment object containing
the HUMAnN gene families, such as those provided by
curatedMetagenomicData, so its feature-wise information on genes and
taxa are added to the rowData. This makes ariadne interoperable with
HUMAnN gene families data.

## Usage

``` r
processGeneFamilies(x)
```

## Arguments

- x:

  A
  [`SummarizedExperiment`](https://rdrr.io/pkg/SummarizedExperiment/man/SummarizedExperiment-class.html)
  object.

## Value

An object of the same type as `x` with four additional columns in the
rowData: uniref90, taxname, genus and species.

## Examples

``` r
library(curatedMetagenomicData)

# Import gene families
genes <- curatedMetagenomicData(
    "AsnicarF_2017.gene_families",
    dryrun = FALSE
)
#> 
#> 

# Extract experiment from list
genes <- genes[[1]]

# Process gene families
genes <- processGeneFamilies(genes)

# Print head of rowData
head(rowData(genes, use.names = FALSE))
#> DataFrame with 6 rows and 4 columns
#>              uniref90                taxname          genus
#>           <character>            <character>    <character>
#> 1 UniRef90_A0A1D7PV13 g__Escherichia.s__Es.. g__Escherichia
#> 2 UniRef90_A0A1D7PV13 g__Raoultella.s__Rao..  g__Raoultella
#> 3 UniRef90_A0A377VU77 g__Klebsiella.s__Kle..  g__Klebsiella
#> 4     UniRef90_F4NR79 g__Escherichia.s__Es.. g__Escherichia
#> 5     UniRef90_K0X0S2 g__Escherichia.s__Es.. g__Escherichia
#> 6     UniRef90_J7QIY4 g__Klebsiella.s__Kle..  g__Klebsiella
#>                  species
#>              <character>
#> 1    s__Escherichia_coli
#> 2 s__Raoultella_ornith..
#> 3 s__Klebsiella_pneumo..
#> 4    s__Escherichia_coli
#> 5    s__Escherichia_coli
#> 6 s__Klebsiella_pneumo..
```
