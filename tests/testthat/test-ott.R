
test_that("ott", {

    # Query from ncbi ids
    ncbi_ids <- factor(c(562, 1423, 1280))
    ott_out <- .queryOTT("ncbi", "ott", ncbi_ids, 1e6)
    tax_names <- .queryOTT("ncbi", "name", ncbi_ids, 1e6)

    # Qeury from ott ids
    ott_ids <- factor(c("474506", "1084928", "1090496"))
    ncbi_out <- .queryOTT("ott", "ncbi", ott_ids, 1e6)
    tax_names <- .queryOTT("ott", "name", ott_ids, 1e6)
    
    # Query silva ids
    silva_ids <- .queryOTT("ott", "silva", ott_ids, 1e6)
    silva_ids <- .queryOTT("ncbi", "silva", ncbi_ids, 1e6)
    
    # Query from taxnames
    names <- c("Escherichia coli", "Bacillus subtilis", "Staphylococcus aureus")
    ott_out <- .queryOTT("name", "ott", names, 1e6)
    silva_ids <- .queryOTT("name", "silva", names, 1e6)
})
