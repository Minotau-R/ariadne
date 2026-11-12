# Build ariadne resource graph

`ariadne` imports the resource graph hosted in the companion package
ariadneDB.

## Usage

``` r
ariadne(versions = NULL)
```

## Arguments

- versions:

  `Character list`. A named list of resource versions to load. Latest
  versions are used if not specified. (Default: `NULL`)

## Value

An igraph object with the ariadne resource graph.

## See also

- [`listResourceVersions`](https://minotau-r.github.io/ariadne/reference/listResourceVersions.md)

- ariadneDB: <https://github.com/Minotau-R/ariadneDB>

- Zenodo: <https://zenodo.org/records/18788725>

## Examples

``` r
# Import default resource graph
graph <- ariadne()

# Specify custom resource versions
versions <- list(BugSigDB = "v1.2.2", WoL = "v20April2021")
graph <- ariadne(versions = versions)
```
