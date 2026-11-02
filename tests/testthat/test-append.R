
test_that("append", {
    
    data("Tengeler2020", package = "mia")
    tse <- Tengeler2020
    
    expect_error(
        getSets(tse, butyrate, key = "wrong"),
        "'key' must be 'row.names' or a variable of 'x'.",
        fixed = TRUE
    )
    
    expect_error(
        getSets(tse, butyrate, by = "wrong"),
        "'by' must be either 'rows' or 'cols'.",
        fixed = TRUE
    )
    
    expect_error(
        getSets(tse, butyrate, key = "Genus", names = "wrong"),
        "'x.names' must be TRUE or FALSE.",
        fixed = TRUE
    )
    
    cpd.name <- "Butanoic acid"
    col.names <- c(names(rowData(tse)), cpd.name)
    
    sets <- getSets(tse, butyrate, key = "Genus", x.names = TRUE)
    tse <- addSets(tse, butyrate, key = "Genus", names = TRUE)
    
    expect_s3_class(sets, "data.frame")
    expect_in(colnames(sets), "C00246")
    expect_in(rownames(sets), rownames(tse))
    expect_contains(sets$C00246, c(TRUE, FALSE))
    
    expect_s4_class(tse, "TreeSummarizedExperiment")
    expect_in(names(rowData(tse)), col.names)
    expect_contains(rowData(tse)[[cpd.name]], c(TRUE, FALSE))
})
