## Programmatic access and formatting of U.S Food And Drug Administration (FDA) Orange Book data
### The FDA provides public access to the list of approved drug products (i.e. the Orange Book).
https://www.fda.gov/Drugs/InformationOnDrugs/    
For some reasons, that list can be retrieved from two distinct resources: 
https://www.fda.gov/downloads/Drugs/InformationOnDrugs/UCM163762.zip
and
https://www.fda.gov/downloads/Drugs/InformationOnDrugs/UCM527389.zip

The archive features three data files, i.e. 
exclusivity.txt
patent.txt
products.txt

As of March 2019, the products.txt table contains 36,771 entries, with the following list of attributes:  
Ingredient    
DF;Route  
Trade_Name  
Applicant  
Strength  
Appl_Type  
Appl_No  
Product_No  
TE_Code  
Approval_Date  
RLD  
RS  
Type  
Applicant_Full_Name  

Detail descriptions of these variables are posted at https://www.fda.gov/drugs/informationondrugs/ucm129689.htm#descriptions

The Appl_Type attribute features two mutually exclusive values: "A" or "N".  
"N" stands for New Drug Applications while "N" refers to generic (aka ANDA for Abbreviated New Drug Applications).  

**References**<br />
[PubChem Substance and Compound databases](https://doi.org/10.1093/nar/gkv951) Nucleic Acids Research, Vol. 44, Issue D1, 04 January 2016.      
[PUG-SOAP and PUG-REST: web services for programmatic access to chemical information in PubChem](https://doi.org/10.1093/nar/gkv396) Nucleic Acids Research, 2015, Vol. 43, Web Server issue W605–W611.  
[Structured Product Labeling](https://www.fda.gov/media/71110/download) Guidance for Industry: Indexing Structured Product Labeling. 
