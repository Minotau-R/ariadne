
#' @importFrom BiocParallel bplapply
#' @importFrom data.table rbindlist
.querySPARQL <- function(from, to, specFrom, specTo, endpoint, init, timeout,
    flip = FALSE, batch.size = 25000, workers = NULL, factor = 3){
    # Combine origin and target
    spterms <- c(from, to)
    names(spterms) <- c(specFrom, specTo)
    # Invert features if flipped
    if( flip ) spterms <- rev(spterms)
    # Select similarity level for uniref clusters
    uniref.identity <- switch(spterms[2], uniref50 = 0.5, uniref90 = 0.9)
    # Remove identity level from UniRef
    uniref_idx <- which(spterms == "uniref")
    spterms[uniref_idx] <- "uniref"
    # Set common prefixes
    preface <- paste0("
        PREFIX chemrof: <https://w3id.org/chemrof/>
        PREFIX enzyme: <http://purl.uniprot.org/enzyme/>
        PREFIX obo: <http://purl.obolibrary.org/obo/>
        PREFIX oboInOwl: <http://www.geneontology.org/formats/oboInOwl#>
        PREFIX protein: <http://purl.uniprot.org/uniprot/>
        PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
        PREFIX rh: <http://rdf.rhea-db.org/>
        PREFIX taxon: <http://purl.uniprot.org/taxonomy/>
        PREFIX uniref: <http://purl.uniprot.org/uniref/>
        PREFIX up: <http://purl.uniprot.org/core/>
        
        SELECT DISTINCT ?", paste(spterms, collapse = " ?"), "
        WHERE {
        "
    )
    # Build triple based on from and to
    triple <- .triple_table(spterms, uniref.identity)
    # Find starts and ends of init ranges
    ranges <- .get_batches(init, batch.size, workers, factor)
    # Query SPARQL for each range
    out.list <- bplapply(ranges, function(i){
        x <- init[i[1]:i[2]]
        query <- .composeSPARQL(spterms, preface, triple, endpoint, x)
        resp <- .sendSPARQL(query, endpoint, timeout)
    })
    # Bind output linkmaps
    out <- rbindlist(out.list)
    # Revert columns if flipped
    if( flip ) out <- rev(out)
    return(out)
}


#' @importFrom data.table fread
#' @importFrom httr2 request req_headers req_timeout req_perform resp_body_string req_body_form
.sendSPARQL <- function(query, endpoint, timeout) {
    # Get base url from endpoint table
    endpoint <- .endpoint_table(endpoint)
    # Build request with Accept header for CSV format
    req <- request(endpoint) |>
        req_method("POST") |>
        req_body_form(query = query) |>
        req_headers(Accept = "text/csv") |>
        req_timeout(timeout)
    # Get response
    resp <- req_perform(req)
    # Parse CSV content into data frame
    linkmap <- fread(text = resp_body_string(resp), header = TRUE)
    return(linkmap)
}


.composeSPARQL <- function(spterms, preface, clause, endpoint, init){
    # If init is defined
    if( !is.null(init) && length(init) != 0L ){
        # Limit query with values
        values <- paste0(
            "VALUES ?", spterms[1], " {\n",
                paste(.iri_table(init, spterms, endpoint), collapse = " "), "
            }\n")
        # Pre-append values to clause
        clause <- paste0(values, clause)
    }
    # Build query
    query <- paste0(preface, clause, "\n}")
    return(query)
}


.endpoint_table <- function(endpoint){
  
    endpoint <- switch(endpoint,
        Rhea = "https://sparql.rhea-db.org/",
        UniProt = "https://sparql.uniprot.org/"
    )
    
    return(endpoint)
}


.triple_table <- function(spterms, uniref.identity){
    # Define internal features
    internals <- c(
        "uniref", "uniprotkb", "taxid", "ec", "rhea", "chebi", "inchikey",
        "inchi", "smiles", "name"
    )
    # Find index of external if any
    ext_idx <- which(!spterms %in% internals)
    # Retrieve external generic and specific names
    ext <- spterms[ext_idx]
    # Select UniRef identity level
    which_uniref <- ifelse(spterms[2] == "uniref", paste0("
        ?uniref up:identity ", uniref.identity, ".
    "), "")
    
    uniref2taxid <- paste0(
        which_uniref, "
        # Bind UniRef ids to cluster members
        ?uniref up:member ?member.
        # Bind cluster members to taxa
        ?member up:organism ?taxid.
    ")
    
    taxid2name <- "
        # Bind taxa to scientific names
        ?taxid up:scientificName ?name.
    "
    
    uniref2uniprotkb <- paste0(
        which_uniref, "
        ?uniprotkb up:representativeFor ?uniref.
    ")
    
    uniprotkb2ec <- "
        ?uniprotkb (up:enzyme|up:domain/up:enzyme|up:component/up:enzyme) ?ec.
    "
    
    uniref2ec <- paste0(uniref2uniprotkb, uniprotkb2ec)
    
    uniprotkb2external <- paste0("
        ?uniprotkb a up:Protein.
        ?uniprotkb rdfs:seeAlso ?", ext, ".
        ?", ext, " up:database <http://purl.uniprot.org/database/", names(ext), ">.
    ")
    
    uniref2external <- paste0(uniref2uniprotkb, uniprotkb2external)
    
    uniprotkb2rhea <- "
        ?uniprotkb up:annotation/up:catalyticActivity/up:catalyzedReaction ?rhea.
    "
    
    uniref2rhea <- paste0(uniref2uniprotkb, uniprotkb2rhea)
    
    name2chebi <- "
        ?chebi up:name ?name.
    "
    
    rhea2chebi <- "
        ?rhea rdfs:subClassOf rh:Reaction.
        ?rhea rh:side/rh:contains/rh:compound ?compound.
        # chebi is small molecule, reactive part of macromolecule or polymer
        ?compound rh:chebi|rh:reactivePart/rh:chebi|rh:underlyingChebi ?chebi.
    "
    
    inchi2chebi <- "
        ?chebi chemrof:inchi_string ?inchi.
    "
    
    inchikey2chebi <- "
        ?chebi chemrof:inchi_key_string ?inchikey.  
    "
    
    smiles2chebi <- "
        ?chebi chemrof:smiles_string ?smiles.
    "
    
    rhea2inchi <- paste0(rhea2chebi, inchi2chebi)
    rhea2inchikey <- paste0(rhea2chebi, inchikey2chebi)
    smiles2rhea <- paste0(rhea2chebi, smiles2chebi)
    
    rhea2ec <- "
        ?rhea rdfs:subClassOf rh:Reaction.
        ?rhea rh:ec ?ec.
    "
    
    rhea2external <- paste0("
        ?master rdfs:subClassOf rh:Reaction.
        {
            ?master rdfs:seeAlso ?", ext, ".
            BIND(?master as ?rhea)
        }
        UNION
        {
            ?master rh:directionalReaction|rh:bidirectionalReaction ?alter.
            ?alter rdfs:seeAlso ?", ext, ".
            BIND(?alter as ?rhea)
        }
        FILTER(contains(str(?", ext, "), '", names(ext), "'))
    ")
    
    chebi2external <- paste0("
        ?chebi oboInOwl:hasDbXref ?", ext, ".
        FILTER(contains(?", ext, ", '", names(ext), ":'))
    ")
    
    key <- spterms |>
        sort() |>
        rev() |>
        paste(collapse = "2")
    
    triple <- switch(
        key,
        uniref2taxid = uniref2taxid,
        taxid2name = taxid2name,
        uniref2uniprotkb = uniref2uniprotkb,
        uniref2ec = uniref2ec,
        uniprotkb2ec = uniprotkb2ec,
        uniprotkb2rhea = uniprotkb2rhea,
        uniref2rhea = uniref2rhea,
        rhea2chebi = rhea2chebi,
        name2chebi = name2chebi,
        rhea2ec = rhea2ec,
        inchi2chebi = inchi2chebi,
        inchikey2chebi = inchikey2chebi,
        smiles2chebi = smiles2chebi,
        rhea2inchi = rhea2inchi,
        rhea2inchikey = rhea2inchikey,
        smiles2rhea = smiles2rhea,
        "external"
    )
    
    if( triple == "external" ){
      
        internal <- setdiff(spterms, ext)
        
        triple <- switch(
            internal,
            uniprotkb = uniprotkb2external,
            uniref = uniref2external,
            rhea = rhea2external,
            chebi = chebi2external
        )
    }
    
    return(triple)
}


.iri_table <- function(x, spterms, endpoint) {
    
    iri <- switch(
        spterms[1],
        chebi = "obo",
        uniprotkb = "protein",
        uniref = "uniref",
        taxid = "taxon",
        ec = "enzyme",
        rhea = "rh",
        smiles = "",
        inchi = "",
        inchikey = "",
        name = "",
        "external"
    )
    
    specFrom <- names(spterms)[1]
    is_external <- iri == "external"
    
    if( is_external && spterms[2] == "chebi" ){
        x <- paste0("'", specFrom, ":", x, "'")
    }else if( is_external ){
        # Get IRI for origin feature
        iri <- .get_external_iri(specFrom, endpoint)
        # Add IRI to initial values
        x <- paste0("<", iri, x, ">")
    }else if( iri == "" ){
        x <- paste0("'", x, "'")
    }else{
        x <- paste0(iri, ":", x)
    }
    
    return(x)
}


#' @importFrom stringi stri_replace_first_regex
.get_external_iri <- function(ext, endpoint, limit = 10) {
    
    uniprot_query <- paste0("
        PREFIX up: <http://purl.uniprot.org/core/>
        PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
        SELECT DISTINCT ?entry
        WHERE {
            ?protein a up:Protein.
            ?protein rdfs:seeAlso ?entry.
            ?entry up:database <http://purl.uniprot.org/database/", ext, ">.
    ")
    
    rhea_query <- paste0("
        PREFIX rh: <http://rdf.rhea-db.org/>
        PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
        SELECT DISTINCT ?entry
        WHERE {
            ?rhea rdfs:subClassOf rh:Reaction.
            ?rhea rdfs:seeAlso ?entry.
            FILTER(contains(str(?entry), '", ext, "'))
    ")
    
    query <- switch(endpoint, Rhea = rhea_query, UniProt = uniprot_query)
    query <- paste0(query, "} LIMIT ", limit)
    # Retrieve all unique IRIs from first N bindings
    iri <- query |>
        .sendSPARQL(endpoint, 1e6) |>
        unlist(use.names = FALSE) |>
        stri_replace_first_regex("([^/]+)$", "") |>
        unique()
    
    if( length(iri) > 1L ){
        stop("Multiple prefixes were found in the selected database",
            call. = FALSE)
    }
    
    return(iri)
}


#' @importFrom BiocParallel bpworkers
.get_batches <- function(x, batch.size, workers, factor){
    
    if( is.null(x) ){
        return(list(c(1L, 1L)))
    }
    
    xlen <- length(x)
    
    if( is.null(workers) ){
        workers <- bpworkers()
    }
    
    batch.num <- min(ceiling(xlen / batch.size), factor * workers)
    adapted.size <- ceiling(xlen / batch.num)
    
    if( adapted.size > batch.size ){
        stop("Query limit was reached (", adapted.size, " > ", batch.size, ").",
            " Increase 'factor', 'batch.size' or 'workers' and try again.",
            call. = FALSE)
    }
    
    ranges <- lapply(seq_len(batch.num), function(i) {
        start <- (i - 1) * adapted.size + 1
        end <- min(i * adapted.size, xlen)
        c(start, end)
    })
    
    return(ranges)
}
