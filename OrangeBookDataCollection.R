#July 25th, 2018
#Acton, MA 01720
#Exploring one source of data related to therapeutically active molecules
#The source URL is https://www.fda.gov/Drugs/InformationOnDrugs/

url.basename <- "https://www.fda.gov/downloads/Drugs/InformationOnDrugs/"

if(!file.exists("LocalEOB"))  {  
  dir.create("LocalEOB")  
} 

#he “Additional Resources” section, a link referred to as “Orange Book Data Files (compressed) 
eob_archive1 <- "UCM163762.zip"
download.file(paste(url.basename, eob_archive1, sep = ""), destfile = paste("LocalEOB", "/", eob_archive1, sep = ""))  

# the Drugs@FDA Data Files 
eob_archive2 <- "UCM527389.zip"
download.file(paste(url.basename, eob_archive1, sep = ""), destfile = paste("LocalEOB", "/", eob_archive2, sep = ""))  





