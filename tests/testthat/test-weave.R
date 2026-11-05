test_that("weave", {
    
    path_df <- drawPath(graph, bugsig ~ ko, 1, "uniref90", "uniref50")
    
    expect_true("uniref90" %in% path_df$from || "uniref90" %in% path_df$to)
    expect_false("uniref50" %in% path_df$from || "uniref50" %in% path_df$to)
    
    expect_error(
        drawPath(graph, bugsig ~ ko, 1, "uniref90", "uniref90"),
        "'include' and 'exclude' cannot overlap.", fixed = TRUE
    )
    
    expect_warning(
        ko2gmm <- weavePath(graph, ko ~ gmm, use.names = TRUE),
        "names for 4 ko ids not found.", fixed = TRUE
    )
    
    expect_equal(ncol(ko2gmm), 4L)
    
    ko2gmm <- weavePath(graph, ko ~ gmm, use.names = FALSE)
    expect_identical(ncol(ko2gmm), 2L)
    
    ec2gmm <- weaveComplex(graph, ec ~ gmm)
    expect_identical(
        colnames(ec2gmm),
        c("ec", "gmm", "cov", "ec.name", "gmm.name")
    )
    
    data("pathMeta", package = "ariadne")
    chebi_ids <- c(15377, 30616, 4167)
    
    chebi2gmm <- weavePath(pathMeta, init = chebi_ids)
    
    expect_s3_class(chebi2gmm, "data.frame")
    expect_s3_class(chebi2gmm$gmm, "factor")
    expect_in(levels(chebi2gmm$chebi), chebi_ids)
})