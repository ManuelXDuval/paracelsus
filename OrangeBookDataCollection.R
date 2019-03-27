################################################################################
# Active Pharmaceutical Ingredients data retrieval                             #
# Authoritative source of data related to therapeutically active molecules     #
# The source URL is https://www.fda.gov/Drugs/InformationOnDrugs/              #
################################################################################
# dependencies
sapply(c("reshape2", "RCurl"), library, character.only = TRUE)

#####~~~~U.S. FDA Orange Book resource active ingredients data retrieval~~~~####
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
########~~~~U.S. NIH PubChem resource query and result set retrieval~~~~########
# setting url string values for consuming pubchem PUG REST API
prolog <- "https://pubchem.ncbi.nlm.nih.gov/rest/pug"
input <- "/compound/name/"
# the DelayFunction sets for issuing successive GET requests, preventing 503 
# Service Unavailable Error
DelayFunction <- function(SecDelay, f) {
  function(...) {
    Sys.sleep(SecDelay)
    f(...)
  }
}
# function to query PubChem Compound DB with Ingredient names to get their CID
QueryPubChem4CID <- function(x){
  gsub("\n", ";", trimws(
    getURL(paste0(prolog, input, gsub(" ", "%20", x),"/cids/TXT"))))
}
# issuing the https get requests
paracelsusDf <- as.data.frame(
  cbind(Ingred2, sapply(Ingred2, DelayFunction(.5, QueryPubChem4CID))))
colnames(paracelsusDf) <- c("Ingredient", "CID")
# filtering out entries with no match to PubChem copound DB
paracelsusDf <- paracelsusDf[!(grepl("NotFound;", paracelsusDf$CID)),]
# the paracelsusDf dataframe: a 1,123 records by 2 attributes: Ingredient Name 
# and PubChem compound CID. 
################################################################################







