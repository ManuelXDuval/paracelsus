################################################################################
# Active Pharmaceutical Ingredients data retrieval                             #
# Authoritative source of data related to therapeutically active molecules     #
# The source URL is https://www.fda.gov/Drugs/InformationOnDrugs/              #
################################################################################
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
################################################################################







