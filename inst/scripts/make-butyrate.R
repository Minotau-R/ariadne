
devtools::load_all()
graph <- ariadne()

tax.names <- c(
    "Butyricimonas", "Odoribacter", "Agathobacter", "Anaerobutyricum",
    "Eubacterium ventriosum", "Anaerostipes", "Butyrivibrio", "Coprococcus",
    "Roseburia", "Shuttleworthia", "Butyricicoccus", "Faecalibacterium",
    "Flavonifractor", "Pseudoflavonifractor", "Oscillibacter", "Subdoligranulum"
)

name2tax <- linkNames(graph, "ott", names = tax.names)

name2tax <- weavePath(graph, ott.name ~ taxid, init = rev(name2tax))

name2cpd <- linkNames(graph, "kegg_cpd", names = "Butanoic acid")

butyrate <- data.frame(
    taxid = name2tax$taxid, kegg_cpd = name2cpd$kegg_cpd,
    taxid.name = name2tax$ott.name, kegg_cpd.name = name2cpd$kegg_cpd.name
)

butyrate[] <- lapply(butyrate, as.factor)

usethis::use_data(butyrate, overwrite = TRUE)
