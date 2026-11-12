# Dataset of butyrate producers

`butyrate` is derived from two observational, population-based
microbiome studies on the associations between butyrate-producing gut
bacteria and the risk of hospitalisation due to infectious diseases. It
provides a set of butyrate producers that were significantly increased
or reduced in the patient group.

## Value

A linkmap with 16 butyrate-producing microbial features characterised at
the genus or species level based on the NCBI taxonomy. Its format
represents a hypothetical output for
[`weavePath`](https://minotau-r.github.io/ariadne/reference/weavePath.md)
with `by` set to `taxid ~ kegg_cpd`, containing the following variables:

- taxid: NCBI taxon identifiers (genus or species)

- kegg_cpd: KEGG compound identifiers (butyrate)

- taxid.name: organism names associated with the taxon identifiers

- kegg_cpd.name: compound names associated with the KEGG identifiers

## References

Kullberg, Robert FJ, et al. "Association between butyrate-producing gut
bacteria and the risk of infectious disease hospitalisation: results
from two observational, population-based microbiome studies." The Lancet
Microbe 5.9 (2024). <https://doi.org/10.1016/S2666-5247(24)00079-X>

## Examples

``` r
# Import linkmap
data("butyrate", package = "ariadne")

# Print some pairs
head(butyrate)
#>     taxid kegg_cpd           taxid.name kegg_cpd.name
#> 1 1017280   C00246 Pseudoflavonifractor Butanoic acid
#> 2 1766253   C00246         Agathobacter Butanoic acid
#> 3  177971   C00246       Shuttleworthia Butanoic acid
#> 4  207244   C00246         Anaerostipes Butanoic acid
#> 5  216851   C00246     Faecalibacterium Butanoic acid
#> 6 2569097   C00246      Anaerobutyricum Butanoic acid
```
