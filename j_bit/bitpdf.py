import os
import csv
with open('bitdoi.csv', newline='') as csvfile:

    doi_list = csv.reader(csvfile)
    rows = list(doi_list)

    doibyyear = [59,139,235,321,419,523,631,746,859,952,1025,1082,1128,1180,1231,1273]

    year = 0    
    i = 1
    while(year<=15):
        while(i<doibyyear[year]):
            doi = rows[i][1]
            command = "scihub -s "+doi+" -O "+str(2021-year)+"_vol"+str(40-year)
            os.system(command)
            i += 1
        i = doibyyear[year]
        year += 1
        
