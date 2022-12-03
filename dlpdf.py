import os
import csv
with open("IHCI/ihcidoi.csv", newline='') as csvfile:

    doi_list = csv.reader(csvfile)
    rows = list(doi_list)
    outputfile = rows[1][0]
    for i in rows: 
        if(i[1]==""):
            outputfile = i[0]
            continue
        doi = i[1]
        command = "scihub -s "+doi+" -O IHCI/"+ outputfile
        os.system(command)
