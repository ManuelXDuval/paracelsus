################################################################################
# Active Pharmaceutical Ingredients data retrieval                             #
# Authoritative source of data related to therapeutically active molecules     #
# The source URL is https://www.fda.gov/Drugs/InformationOnDrugs/              #
################################################################################

# resource location.
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
# extract data files
unzip("LocalEOB/UCM163762.zip", exdir = "LocalEOB/")


################################################################################







