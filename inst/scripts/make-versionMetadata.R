
devtools::load_all()
source("inst/scripts/utils.R")

default.graph <- 23584782
dfs <- list()

# Add BugSigDB versions
record_id <- 5606166
versions <- fetch_zenodo_versions(record_id)

dfs[["BugSigDB"]] <- data.frame(
    version = names(versions), key = versions, graph = default.graph
)

# Add ChocoPhlAn versions
record_id <- 17100034
versions <- fetch_zenodo_versions(record_id)

dfs[["ChocoPhlAn"]] <- data.frame(
    version = names(versions), key = versions, graph = default.graph
)

# Add MSigDB versions
record_id <- 15377497
versions <- fetch_zenodo_versions(record_id)

dfs[["MSigDB"]] <- data.frame(
    version = names(versions), key = versions, graph = default.graph
)

# Add GO versions
page <- "https://release.geneontology.org/"

versions <- page |>
    fetch_page_links() |>
    str_extract("\\d{4}-\\d{2}-\\d{2}") |>
    rev()

years <- versions |>
    substr(1, 4) |>
    as.numeric()

versions <- versions[years >= 2025]

dfs[["GO"]] <- data.frame(
    version = versions, key = versions, graph = default.graph
)

# Add WoL versions
dfs[["WoL"]] <- data.frame(
    version = c("v2", "v20April2021"),
    key = c("wol2", "wol-20April2021"),
    graph = c(default.graph, 18788726)
)

# Add Misc versions
dfs[["GM"]] <- data.frame(
    version = "v1",
    key = "omixer/omixer-rpmR/raw/refs/heads/main/inst/extdata",
    graph = default.graph
)

# Add TIGRFAMs versions
dfs[["TIGRFAMs"]] <- data.frame(
    version = "v15", key = "release_15.0", graph = default.graph
)

# Add unversioned resources
not_versioned <- c("enviPath", "KEGG", "OTT", "Rhea", "UniProt")
nover_dfs <- lapply(
    not_versioned,
    function(x) data.frame(version = "latest", key = "", graph = default.graph)
)
# Add names to dataframes for unversioned resources
names(nover_dfs) <- not_versioned

# Bind all resource dataframes
df <- bind_rows(c(dfs, nover_dfs), .id = "source")
rownames(df) <- NULL

# Set latest versions as default
df$default <- !duplicated(df$source)
# Order resources alphabetically
df <- df[order(df$source), ]

meta <- listResourceMetadata()
attr(df, "urls") <- setNames(meta$url, meta$resource)

df -> versionMetadata
usethis::use_data(versionMetadata, internal = TRUE, overwrite = TRUE)
