#' Dataset of butyrate producers
#' 
#' \code{butyrate} is derived from two observational, population-based
#' microbiome studies on the associations between butyrate-producing gut
#' bacteria and the risk of hospitalisation due to infectious diseases. It
#' provides a set of butyrate producers that were significantly increased or
#' reduced in the patient group.
#' 
#' @returns
#' A linkmap with 16 butyrate-producing microbial features characterised at the
#' genus or species level based on the NCBI taxonomy. Its format represents a
#' hypothetical output for \code{\link{weavePath}} with \code{by} set to
#' \code{taxid ~ kegg_cpd}, containing the following variables:
#' 
#' \itemize{
#'   \item taxid: NCBI taxon identifiers (genus or species)
#'   \item kegg_cpd: KEGG compound identifiers (butyrate) 
#'   \item taxid.name: organism names associated with the taxon identifiers
#'   \item kegg_cpd.name: compound names associated with the KEGG identifiers
#' }
#' 
#' @references 
#' Kullberg, Robert FJ, et al.
#' "Association between butyrate-producing gut bacteria and the risk of
#' infectious disease hospitalisation: results from two observational,
#' population-based microbiome studies." The Lancet Microbe 5.9 (2024).
#' \url{https://doi.org/10.1016/S2666-5247(24)00079-X}
#' 
#' @examples
#' # Import linkmap
#' data("butyrate", package = "ariadne")
#' 
#' # Print some pairs
#' head(butyrate)
#' @name butyrate
#' @importFrom utils data
NULL


#' Data frame for pathway from chebi to gmm
#' 
#' \code{pathMeta} provides a minimal example of a data frame describing one
#' pathway in the ariadne graph from chebi to gmm. This kind of data frame is
#' typically the output of \code{\link{drawPath}} and works as input for
#' \code{\link{weavePath}} and \code{\link{weaveComplex}}.
#' 
#' @returns
#' A pathway data frame with four rows (steps) and four columns (from, to,
#' source and version).
#' 
#' @examples
#' # Import data frame for pathway from chebi to gmm
#' data("pathMeta", package = "ariadne")
#' 
#' # Print pathway data frame
#' pathMeta
#' 
#' # Recreate pathMeta using ariadne
#' # graph <- ariadne()
#' # pathMeta <- drawPath(graph, chebi ~ gmm, include = "rhea")
#' @name pathMeta
#' @importFrom utils data
NULL
