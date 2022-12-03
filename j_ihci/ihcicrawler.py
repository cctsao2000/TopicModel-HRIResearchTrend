from bs4 import BeautifulSoup
import requests
import csv

with open("ihcidoi.csv", mode="a", newline='') as ihci_doi:
    writer = csv.writer(ihci_doi)
    # writer.writerow(["pName", "doi"])

    year = "2006"
    volume = 20
    issues = ["1","2","3"]
    # issues = ["1","2","3","4","5","6","7","8"]
    # issues = ["1","2","3","4","5","6","7","8","9","10","11","12"]

    writer.writerow(["Vol"+str(volume)+"_"+year])
    for issue in issues:
        response = requests.get("https://www.tandfonline.com/toc/hihc20/"+str(volume)+"/"+issue+"?nav=tocList")
        soup = BeautifulSoup(response.text, "html.parser")
        titles = soup.find_all("div", {"class": "art_title linkable"})
        for title in titles:
            writer.writerow([title.select_one("span").text,title.select_one("a").get("href").split("/",3)[3]])
