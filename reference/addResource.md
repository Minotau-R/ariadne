# Add resources to graph

`addResource` includes a user-defined resource to the ariadne graph.

## Usage

``` r
addResource(graph, ...)

# S4 method for class 'igraph'
addResource(
  graph,
  by,
  file,
  res.name = "Custom",
  force = FALSE,
  timeout = 1e+06,
  ...
)
```

## Arguments

- graph:

  An igraph object.

- ...:

  Additional arguments passed to
  [`fread`](https://rdrr.io/pkg/data.table/man/fread.html).

- by:

  A formula specifying the custom path to add.

- file:

  `Character scalar`. The path to a local or remote file that stores the
  linkmap between two features types corresponding `by`. It must be a
  table with two columns and each row representing a binding between
  features.

- res.name:

  `Character scalar`. The name of the resource that will appear in the
  output graph. (Default: `"Custom"`)

- force:

  `Logical scalar`. Whether `file` should overwrite any previously
  cached files with the same name. (Default: `FALSE`)

- timeout:

  `Numeric scalar`. The timeout for downloading resources. (Default:
  `1e6`)

## Value

An igraph object.

## Examples

``` r
# Retrieve resource graph
graph <- ariadne()

# Set URL to custom resource
url <- "https://ftp.ebi.ac.uk/pub/databases/amr_portal/releases/2025-12/"
url <- paste0(url, "phenotype_genotype_merged.csv.gz")

# Add resource to ariadne graph
graph <- addResource(
    graph,
    taxid ~ aro,
    url,
    res.name = "AMR",
    select = c("taxon_id", "antibiotic_ontology")
)

# Search for newly added path
searchPath(graph, taxid ~ aro)
#> Path 1:
#> taxid -(AMR)-> aro
#> 

# Plot newly added path
plotPath(graph, taxid ~ aro, focus = TRUE)
#> Using "stress" as default layout


# Find antibiotics related to E. coli (NCBI 562)
tax2aro <- weavePath(graph, taxid ~ aro, init = 562)
#> taxid -(AMR)-> aro
```
