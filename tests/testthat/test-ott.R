
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

test_that("ott unknown ids", {
    # Mock a 400 response, i.e., an id unknown to OTT
    httr2::local_mocked_responses(function(req) {
        httr2::response(status_code = 400L)
    })
    # Unknown id returns a single missing value instead of an error
    expect_no_error(
        res <- .queryTaxonInfo(1, "ott", "ott_id", 10)
    )
    expect_identical(res, NA)
    expect_identical(.queryTaxonInfo(1, "name", "ott_id", 10), NA)
    expect_identical(.queryTaxonInfo("ncbi:1", "ncbi", "source_id", 10), NA)
})

test_that("ott other http errors are not silenced", {
    # Only 400 is handled; other error statuses must still raise an error
    httr2::local_mocked_responses(function(req) {
        httr2::response(status_code = 500L)
    })
    expect_error(.queryTaxonInfo(1, "ott", "ott_id", 10))
    httr2::local_mocked_responses(function(req) {
        httr2::response(status_code = 404L)
    })
    expect_error(.queryTaxonInfo(1, "ott", "ott_id", 10))
})

test_that("ott empty response", {
    # Successful response with empty body returns a missing value
    httr2::local_mocked_responses(function(req) {
        httr2::response_json(status_code = 200L, body = list())
    })
    expect_identical(.queryTaxonInfo(1, "ott", "ott_id", 10), NA)
})

test_that("ott successful response", {
    # Successful response is parsed as before
    httr2::local_mocked_responses(function(req) {
        httr2::response_json(
            status_code = 200L,
            body = list(
                ott_id = 474506L, unique_name = "Escherichia coli",
                tax_sources = list("ncbi:562", "gbif:3221001")
            )
        )
    })
    expect_identical(.queryTaxonInfo(1, "ott", "ott_id", 10), 474506L)
    expect_identical(
        .queryTaxonInfo(1, "name", "ott_id", 10), "Escherichia coli"
    )
    expect_identical(.queryTaxonInfo(1, "ncbi", "ott_id", 10), "ncbi:562")
    # Prefix is matched exactly: "if" must not match "gbif"
    expect_length(.queryTaxonInfo(1, "if", "ott_id", 10), 0L)
})
