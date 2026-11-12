# List resource versions registered in the ariadne database

listResourceVersions shows the available versions for the different
resources registered in the ariadne database. Any of those versions can
be passed to
[`ariadne`](https://minotau-r.github.io/ariadne/reference/ariadne.md).
Resources labelled with `"latest"` cannot be versioned as they are
dynamically accessed via their API or SPARQL endpoint.

## Usage

``` r
listResourceVersions(default = FALSE)
```

## Arguments

- default:

  `Logical scalar`. Should only default versions be listed. (Default:
  `FALSE`)

## Value

A data.frame with information on registered resource versions.

## See also

[`ariadne`](https://minotau-r.github.io/ariadne/reference/ariadne.md)

## Examples

``` r
# View all available resource versions
listResourceVersions()
#>      resource      version
#> 1    BugSigDB       v1.3.1
#> 2    BugSigDB       v1.3.0
#> 3    BugSigDB       v1.2.2
#> 4    BugSigDB       v1.2.1
#> 5    BugSigDB       v1.2.0
#> 6    BugSigDB       v1.1.0
#> 7    BugSigDB       v1.0.2
#> 8    BugSigDB       v1.0.1
#> 9    BugSigDB       v1.0.0
#> 10 ChocoPhlAn     v201901b
#> 11   enviPath       latest
#> 12         GM           v1
#> 13         GO   2026-08-05
#> 14         GO   2026-06-19
#> 15         GO   2026-05-19
#> 16         GO   2026-03-25
#> 17         GO   2026-01-23
#> 18         GO   2025-10-10
#> 19         GO   2025-07-22
#> 20         GO   2025-06-01
#> 21         GO   2025-03-16
#> 22         GO   2025-02-06
#> 23       KEGG       latest
#> 24     MSigDB       2026.1
#> 25     MSigDB       2025.1
#> 26     MSigDB       2024.1
#> 27        OTT       latest
#> 28       Rhea       latest
#> 29   TIGRFAMs          v15
#> 30    UniProt       latest
#> 31        WoL           v2
#> 32        WoL v20April2021
#>                                                                        url
#> 1                                     https://zenodo.org/records/19740674/
#> 2                                     https://zenodo.org/records/15272273/
#> 3                                     https://zenodo.org/records/13997429/
#> 4                                     https://zenodo.org/records/10627578/
#> 5                                     https://zenodo.org/records/10407666/
#> 6                                      https://zenodo.org/records/6468009/
#> 7                                      https://zenodo.org/records/5904281/
#> 8                                      https://zenodo.org/records/5819260/
#> 9                                      https://zenodo.org/records/5606166/
#> 10                                    https://zenodo.org/records/17100034/
#> 11                                                  https://envipath.org//
#> 12 https://github.com/omixer/omixer-rpmR/raw/refs/heads/main/inst/extdata/
#> 13                            https://release.geneontology.org/2026-08-05/
#> 14                            https://release.geneontology.org/2026-06-19/
#> 15                            https://release.geneontology.org/2026-05-19/
#> 16                            https://release.geneontology.org/2026-03-25/
#> 17                            https://release.geneontology.org/2026-01-23/
#> 18                            https://release.geneontology.org/2025-10-10/
#> 19                            https://release.geneontology.org/2025-07-22/
#> 20                            https://release.geneontology.org/2025-06-01/
#> 21                            https://release.geneontology.org/2025-03-16/
#> 22                            https://release.geneontology.org/2025-02-06/
#> 23                                             https://www.genome.jp/kegg/
#> 24                                    https://zenodo.org/records/18968178/
#> 25                                    https://zenodo.org/records/15800824/
#> 26                                    https://zenodo.org/records/15377497/
#> 27                                       https://opentreeoflife.github.io/
#> 28                                                https://www.rhea-db.org/
#> 29                 https://ftp.ncbi.nlm.nih.gov/hmm/TIGRFAMs/release_15.0/
#> 30                                                https://www.uniprot.org/
#> 31                                       https://ftp.microbio.me/pub/wol2/
#> 32                            https://ftp.microbio.me/pub/wol-20April2021/

# View default resource versions
listResourceVersions(default = TRUE)
#>      resource    version
#> 1    BugSigDB     v1.3.1
#> 2  ChocoPhlAn   v201901b
#> 3    enviPath     latest
#> 4          GM         v1
#> 5          GO 2026-08-05
#> 6        KEGG     latest
#> 7      MSigDB     2026.1
#> 8         OTT     latest
#> 9        Rhea     latest
#> 10   TIGRFAMs        v15
#> 11    UniProt     latest
#> 12        WoL         v2
#>                                                                        url
#> 1                                     https://zenodo.org/records/19740674/
#> 2                                     https://zenodo.org/records/17100034/
#> 3                                                   https://envipath.org//
#> 4  https://github.com/omixer/omixer-rpmR/raw/refs/heads/main/inst/extdata/
#> 5                             https://release.geneontology.org/2026-08-05/
#> 6                                              https://www.genome.jp/kegg/
#> 7                                     https://zenodo.org/records/18968178/
#> 8                                        https://opentreeoflife.github.io/
#> 9                                                 https://www.rhea-db.org/
#> 10                 https://ftp.ncbi.nlm.nih.gov/hmm/TIGRFAMs/release_15.0/
#> 11                                                https://www.uniprot.org/
#> 12                                       https://ftp.microbio.me/pub/wol2/
```
