

# Paracelsus
"Man is a microcosm, or a little world, because he is an extract from all the stars and planets of the whole firmament, from the earth and the elements; and so he is their quintessence." Philippus Aureolus Theophrastus Bombastus von Hohenheim, alias Paracelsus.  [https://en.wikipedia.org/wiki/Paracelsus]

This repository is dedicated to the study of compounds with establised or presumptive therapeutic properties. 


- step#1: the OrangeBookDataCollection.R script loads the US FDA Orange Book Products table and returns a set (vector) of non-redundant ingredients.  When invoked, the script downloads ~6MB amount of data to the local storage.

- step#2: the NIH PubChem Compound DB is queried with the set of Orange Book Ingredient names. Tthe PubChem compound CID attributes is retrieved.  

- step#3: curating the current set of ingredients.  
