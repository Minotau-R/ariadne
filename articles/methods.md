# ariadne definitions and technical details

## Introduction

## Definitions

The table below summarises the technical terms used to make sense of
ariadne in its vignettes and underlying code.

| **Term** | **Definition** | **Examples** |
|----|----|----|
| **Feature type** | A distinct type of biological entity with unique elements labeled by IDs. Written in lowercase for consistency. | `genes` (KEGG genes ID), `ko` (KEGG Orthologues), `ec` (Enzyme Commission number), `uniref90` (UniRef sequence clusters) |
| **Level** | A unique element belonging to a feature type. Often referred to as a *feature*. | 563 (NCBI ID for *E. coli*), C00246 (KEGG compound ID for butyrate), P0DTC2 (UniProtKB ID for SARS-CoV-2 spike protein) |
| **Linkmap** | A 2-column data frame with feature types as columns and their links in the rows. Named as `x2y`, where x and y are feature types. | `tax2cpd` (linkmap between taxon names and compounds) |
| **Resource** | A database from which linkmaps between feature types can be retrieved. | KEGG, Rhea, UniProt |
| **Weave** | The operation of sequentially linking feature types to create a new linkmap between two previously unlinked feature types. Uses the syntax `x ~ y`, where x is the origin and y is the target feature type. | `ko ~ ec`, `disease ~ drug`, `genes ~ metacyc` |

## Technical details: strengths and limitations

The ariadne approach provides several advantages to streamline the
mapping workflow. However, it also presents certain downsides worth
considering.

### Graph-based resource representation

Graph-based resource representation \| Focused on established databases

**Graph-based resource representation** using an igraph object where
edges are resources and nodes are feature types, enabling graph theory
for path selection and easy expansion with custom resources.

**Focused on established databases**. Less permanent ones may be added
manually by the user. This is to reduce the odds of unpredicted changes
or disappearing of underlying resources.

**Not always possible to track new databases reproducibly**. Many
databases do not provide programmatic access (or even links) to their
resources, and do not keep past releases accessible, so we do not
include them in the core graph, even though can be manually added by
users.

### Resource query optimisation

Fast queries \| Internet access required

**Fast queries**: with httr2 for API requests and SPARQL for even faster
linkmap retrieval when possible.

### Resource storage and caching

Efficient caching and storage \| Not supported for all resources

**Efficient caching and storage**: to automatically cache linkmaps with
BiocFileCache and store them in the efficient Apache Parquet format via
arrow.

### Cross-resource linkmap generation

Optimised linkmap generation \| Code complexity increases with resource
coverage

**Optimised linkmap generation** through the multifactor class, which
streamlines factor operations to create linkmaps by sequentially
combining them along the path from origin to target feature type.

## Reproducibility

R session information:

    #> R version 4.6.1 (2026-06-24)
    #> Platform: x86_64-pc-linux-gnu
    #> Running under: Ubuntu 24.04.5 LTS
    #> 
    #> Matrix products: default
    #> BLAS:   /usr/lib/x86_64-linux-gnu/openblas-pthread/libblas.so.3 
    #> LAPACK: /usr/lib/x86_64-linux-gnu/openblas-pthread/libopenblasp-r0.3.26.so;  LAPACK version 3.12.0
    #> 
    #> locale:
    #>  [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C               LC_TIME=en_US.UTF-8        LC_COLLATE=en_US.UTF-8    
    #>  [5] LC_MONETARY=en_US.UTF-8    LC_MESSAGES=en_US.UTF-8    LC_PAPER=en_US.UTF-8       LC_NAME=C                 
    #>  [9] LC_ADDRESS=C               LC_TELEPHONE=C             LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C       
    #> 
    #> time zone: UTC
    #> tzcode source: system (glibc)
    #> 
    #> attached base packages:
    #> [1] stats     graphics  grDevices utils     datasets  methods   base     
    #> 
    #> other attached packages:
    #> [1] BiocStyle_2.41.0
    #> 
    #> loaded via a namespace (and not attached):
    #>  [1] digest_0.6.39       desc_1.4.3          R6_2.6.1            bookdown_0.48       fastmap_1.2.0      
    #>  [6] xfun_0.62           cachem_1.1.0        knitr_1.52          htmltools_0.5.9     rmarkdown_2.32     
    #> [11] lifecycle_1.0.5     cli_3.6.6           sass_0.4.10         pkgdown_2.2.1       textshaping_1.0.5  
    #> [16] jquerylib_0.1.4     systemfonts_1.3.2   compiler_4.6.1      tools_4.6.1         ragg_1.5.2         
    #> [21] bslib_0.12.0        evaluate_1.0.5      yaml_2.3.12         BiocManager_1.30.27 otel_0.2.0         
    #> [26] jsonlite_2.0.0      rlang_1.3.0         fs_2.1.0            htmlwidgets_1.6.4
