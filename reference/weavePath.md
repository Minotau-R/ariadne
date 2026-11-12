# Weave paths between resources

`weavePath` and `weaveComplex` build the selected path through the
resource graph from the origin to the target features, fetching and
combining the necessary resources from several databases.

While `weavePath` returns a linkmap with all simple links,
`weaveComplex` yields links only for features mapped above a certain
coverage threshold, which is useful for pathways or functional modules
made of several indispensable components.

## Usage

``` r
weavePath(graph, ...)

weaveComplex(graph, ...)

# S4 method for class 'data.frame'
weavePath(
  graph,
  init = NULL,
  prune = TRUE,
  use.names = TRUE,
  verbose = TRUE,
  timeout = 1e+06,
  ...
)

# S4 method for class 'igraph'
weavePath(
  graph,
  by,
  k = 1,
  include = NULL,
  exclude = NULL,
  res.name = NULL,
  init = NULL,
  prune = TRUE,
  use.names = TRUE,
  verbose = TRUE,
  timeout = 1e+06,
  ...
)

# S4 method for class 'data.frame'
weaveComplex(
  graph,
  init = NULL,
  threshold = 0,
  prune = TRUE,
  use.names = TRUE,
  verbose = TRUE,
  timeout = 1e+06,
  ...
)

# S4 method for class 'igraph'
weaveComplex(
  graph,
  by,
  k = 1,
  include = NULL,
  exclude = NULL,
  res.name = NULL,
  init = NULL,
  threshold = 0,
  prune = TRUE,
  use.names = TRUE,
  verbose = TRUE,
  timeout = 1e+06,
  ...
)
```

## Arguments

- graph:

  An igraph or data.frame object, which can be obtained from
  [`ariadne`](https://minotau-r.github.io/ariadne/reference/ariadne.md)
  and
  [`drawPath`](https://minotau-r.github.io/ariadne/reference/drawPath.md),
  respectively.

- ...:

  Additional arguments.

  - `batch.size`: `Numeric scalar`. The maximum batch size for SPARQL or
    API queries. (Default: half the maximum query size)

  - `workers`: `Numeric scalar`. Number of workers to use, automatically
    detected when `NULL`. (Default: `NULL`)

  - `factor`: `Numeric scalar`. Number of jobs per worker. (Default:
    `3`)

- init:

  `Character vector`. Initial values to prune the first mapping step.
  (Default: `NULL`)

- prune:

  `Logical scalar`. Should the values from each step be used prune the
  following step. (Default: `TRUE`)

- use.names:

  `Logical scalar`. Should feature names be provided in the output in
  addition to feature identifiers. (Default: `TRUE`)

- verbose:

  `Logical scalar`. Should messages be printed in the console. (Default:
  `TRUE`)

- timeout:

  `Numeric scalar`. The timeout for downloading resources. (Default:
  `1e6`)

- by:

  A formula specifying the path to weave.

- k:

  `Numeric scalar`. The kth shortest path to weave. (Default: `1`)

- include:

  `Character vector`. Nodes to cross in the path. (Default: `NULL`)

- exclude:

  `Character vector`. Nodes to avoid in the path. (Default: `NULL`)

- res.name:

  `Character vector`. Names of resources to include in the graph.
  (Default: `NULL`)

- threshold:

  `Numeric scalar`. Only for `weaveComplex`. The coverage threshold
  equal or above which to return links, between 0 and 1 (including the
  limit). If `0`, all links are returned. (Default: `0`)

## Value

A two-column data.frame (x-to-y linkmap), with optional names as a third
column.

## Examples

``` r
# Load resource graph
graph <- ariadne()

# Weave simple path from KEGG diseases to Gut Metabolic Modules (GMMs)
dis2gmm <- weavePath(graph, kegg_disease ~ gmm)
#> kegg_disease -(KEGG)-> ko
#> ko -(GM)-> gmm

# Weave 3rd path from KEGG diseases to GMMs (through KEGG drugs)
dis2gmm <- weavePath(graph, kegg_disease ~ gmm, k = 4)
#> kegg_disease -(KEGG)-> kegg_drug
#> kegg_drug -(KEGG)-> ko
#> ko -(GM)-> gmm

# Weave complex path from KEGG diseases to GMMs
dis2gmm <- weaveComplex(graph, kegg_disease ~ gmm)
#> kegg_disease -(KEGG)-> ko
#> ko -(GM)-> gmm

# Specify coverage threshold
dis2gmm <- weaveComplex(graph, kegg_disease ~ gmm, threshold = 0.8)
#> kegg_disease -(KEGG)-> ko
#> ko -(GM)-> gmm


# Load example pathway dataframe
data("pathMeta", package = "ariadne")

# Weave pathway from chebi to GMMs with three initial chebi IDs
chebi2gmm <- weavePath(pathMeta, init = c(15377, 30616, 4167))
#> chebi -(Rhea)-> rhea
#> rhea -(Rhea)-> ec
#> ec -(KEGG)-> ko
#> ko -(GM)-> gmm


# Import butyrate dataset
data("butyrate", package = "ariadne")

# Weave path starting from initial values
tax2bugsig <- weavePath(graph, taxid ~ bugsig, init = butyrate$taxid)
#> taxid -(BugSigDB)-> bugsig

# Weave path including TaxID
tax2bugsig <- weavePath(
    graph, taxid ~ bugsig, include = "taxid", init = butyrate$taxid
)
#> taxid -(BugSigDB)-> bugsig
```
