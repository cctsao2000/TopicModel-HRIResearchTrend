from bs4 import BeautifulSoup
import requests
import csv

with open("bitdoi.csv", mode="a", newline='') as bit_doi:
    writer = csv.writer(bit_doi)

    issue = 1
    volume = 37
    # while(issue <= 9):
        # writer.writerow(["Vol: "+str(volume)+", Issue: "+str(issue)])
    response = requests.get("https://www.tandfonline.com/toc/tbit20/"+str(volume)+"/12"+"?nav=tocList")
    soup = BeautifulSoup(response.text, "html.parser")
    titles = soup.find_all("div", {"class": "art_title linkable"})
    for title in titles:
        writer.writerow([title.select_one("span").text,title.select_one("a").get("href").split("/",3)[3]])
        # issue += 1
