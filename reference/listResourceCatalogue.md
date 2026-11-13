# Consult catalogue of resources registered in the ariadne database

listResourceCatalogue provides useful information about the available
resources, including related license of usage and primary publications.

## Usage

``` r
listResourceCatalogue()
```

## Value

A data.frame with information on registered resources.

## See also

[`ariadne`](https://minotau-r.github.io/ariadne/reference/ariadne.md)

## Examples

``` r
# View all available resources
listResourceCatalogue()
#>      resource                               url         license
#> 1    BugSigDB       https://zenodo.org/records/      ODC BY 1.0
#> 2  ChocoPhlAn       https://zenodo.org/records/             MIT
#> 3    enviPath             https://envipath.org/ CC BY-NC-SA 4.0
#> 4          GM               https://github.com/            <NA>
#> 5          GO https://release.geneontology.org/       CC BY 4.0
#> 6        KEGG              https://www.kegg.jp/            <NA>
#> 7      MSigDB       https://zenodo.org/records/       CC BY 4.0
#> 8         OTT https://opentreeoflife.github.io/         CC0 1.0
#> 9        Rhea          https://www.rhea-db.org/       CC BY 4.0
#> 10   TIGRFAMs     https://ftp.ncbi.nlm.nih.gov/    CC BY-SA 4.0
#> 11    UniProt           https://www.uniprot.org       CC BY 4.0
#> 12        WoL      https://ftp.microbio.me/pub/            <NA>
#>                                                      doi
#> 1                             10.1038/s41587-023-01872-y
#> 2                              10.1038/s41592-018-0176-y
#> 3                             10.1186/s13321-024-00881-6
#> 4  10.1038/nmicrobiol.2016.88, 10.1038/s41564-018-0337-x
#> 5                                          10.1038/75556
#> 6                                    10.1093/nar/28.1.27
#> 7                                10.1073/pnas.0506580102
#> 8                                10.1073/pnas.1423041112
#> 9                                   10.1093/nar/gkab1016
#> 10                                   10.1093/nar/29.1.41
#> 11                                  10.1093/nar/gkae1010
#> 12                            10.1038/s41467-019-13443-4
```
