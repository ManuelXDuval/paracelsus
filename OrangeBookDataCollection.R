###############################################################################
# Active Pharmaceutical Ingredients data retrieval                            #
# Authoritative source of data related to therapeutically active molecules    #
# The source URL is https://www.fda.gov/Drugs/InformationOnDrugs/             #
###############################################################################
# dependencies
sapply(c("httr", "RCurl", "reshape2", "SPARQL", "stringr", "tidyr"), library, 
       character.only = TRUE)

#####~~~~U.S. FDA Orange Book resource active ingredients data retrieval~~~~###
# setting the source URL
url.basename <- "https://www.fda.gov/downloads/Drugs/InformationOnDrugs/"
# setting a new subdirectory on the local file system where to load the Orange  
# Book data files locally.
if(!file.exists("LocalEOB"))  {  
  dir.create("LocalEOB")  
} 
# the Orange Book archive name 
eob_archive1 <- "UCM163762.zip"
# loading the archive
download.file(paste(url.basename, eob_archive1, sep = ""), 
              destfile = paste("LocalEOB", "/", eob_archive1, sep = ""))  
# extracting data files
unzip("LocalEOB/UCM163762.zip", exdir = "LocalEOB/")

# reading the product.txt data assigning its content to the proDf dataframe
prodDf <- read.table("LocalEOB/products.txt", header = T, sep = "~", quote = "", 
                     comment.char = "", 
                     colClasses = c(rep("character", 4), rep("NULL", 1), 
                                    rep("character", 9)))
# selecting out ANDA and Discontinued
prodDfNDA <- prodDf[(prodDf$Appl_Type == "N" & prodDf$Type == "RX"),]
# setting the list of ingredients. 
Ingred1 <- unique(prodDfNDA$Ingredient[!grepl(";", prodDfNDA$Ingredient)])
CompIngred <- unique(prodDfNDA$Ingredient[grepl(";", prodDfNDA$Ingredient)]) 
CompIngredDf <- colsplit(CompIngred, "\\;", names = c("primIng", "SecondIng"))
Ingred2 <- unique(c(Ingred1, trimws(CompIngredDf$primIng)))
# the Ingred2 vector: active ingredients of the Orange Book prescription drugs

##########~~~~~~~~~~##########~~~~~~~~~~##########~~~~~~~~~~##########~~~~~~~~~~
########~~~~U.S. NIH PubChem resource query and result set retrieval~~~~#######
# setting url string values for issuing queries via the PubChem PUG REST API 
prolog <- "https://pubchem.ncbi.nlm.nih.gov/rest/pug"
input <- "/compound/name/"
# the DelayFunction is set for allowing successive GET requests to the PubChem 
# resource yet preventing 503 Service Unavailable Error
DelayFunction <- function(SecDelay, f) {
  function(...) {
    Sys.sleep(SecDelay)
    f(...)
  }
}
# function to query PubChem Compound DB with Ingredient Name to get their CID
QueryPubChem4CID <- function(x){
  gsub("\n", ";", trimws(
    getURL(paste0(prolog, input, gsub(" ", "%20", x),"/cids/TXT"))))
}
# issuing the https get requests
paracelsusDf <- as.data.frame(
  cbind(Ingred2, sapply(Ingred2, DelayFunction(.5, QueryPubChem4CID))))
colnames(paracelsusDf) <- c("Ingredient", "CID")
# filtering out entries with no match to PubChem compound DB
paracelsusDf <- paracelsusDf[!(grepl("NotFound;", paracelsusDf$CID)),]
# the paracelsusDf dataframe: a 1,150 records by 2 attributes: Ingredient Name 
# and PubChem compound CID. 
###############################################################################

########~~~~curating the list of ingredients~~~################################
# selecting out water
paracelsusDf <- paracelsusDf[(paracelsusDf$CID != 962),]
# selecting out imaging agents
ingredients <- as.character(paracelsusDf$Ingredient)
tokensPerIngredient <- sapply(1:length(ingredients), 
                              function(i) 
                                length(str_split(ingredients, " ")[[i]]))
paracelsusDf <- paracelsusDf[!(paracelsusDf$Ingredient %in%
                                 ingredients[which(tokensPerIngredient > 3)]),]
# data curation: extracting actual API from salt forms
# select ingredients with a single string character value
singleTokenIngredient <- ingredients[which(tokensPerIngredient == 1)]
# select ingredients that are associated with another string
multiTokenIngredient <- ingredients[which(tokensPerIngredient > 1)]
# getting ingredients with only one token
OneTokenIngredient <- setdiff(singleTokenIngredient, 
                              intersect(singleTokenIngredient, 
                                        unlist(
                                          str_split(
                                            multiTokenIngredient, " "))))


##~~NIH NLM Medical Subject Heading resource query and result set retrieval~~##
# setting url string values for issuing queries to the MeSH API
host <- "id.nlm.nih.gov/mesh"
endpoint <- "/lookup/descriptor"
# mapping OrangeBook Ingredient name to MeSH Unique ID
meshSet.df <- do.call("rbind", lapply(
  1:dim(paracelsusDf)[1], function(i) as.data.frame(
    content(GET(paste0(host,endpoint,"?label=", paracelsusDf$Ingredient[i]))))
  ))
# setting dataframe column string values
meshSet.df$MeSH_UniqueID <- gsub("http.*./", "", meshSet.df$resource)
meshSet.df$label <- toupper(meshSet.df$label)
# creating the 3 attributes dataframe object
paracelsusDf.mesh <- merge(paracelsusDf, meshSet.df[,c(2,3)], by.x = "Ingredient", by.y = "label")

###################################################################################



