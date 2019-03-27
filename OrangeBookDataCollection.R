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
# quering PubChem Compound database with Ingredient names to get their CID
paracelsusDf <- as.data.frame(
  cbind(Ingred2 ,gsub(
    "\n", ";", sapply(
      1:length(Ingred2), function(i) trimws(
        getURL(
          paste0(prolog, input, gsub(" ", "%20", Ingred2[i]),"/cids/TXT")))))))
colnames(paracelsusDf) <- c("Ingredient", "CID")
# the paracelsusDf dataframe: a 1,242 records by 2 attributes: Ingredient Name 
# and PubChem compound CID. 
################################################################################







