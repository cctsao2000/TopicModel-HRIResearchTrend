from bs4 import BeautifulSoup
import ssl
ssl._create_default_https_context = ssl._create_unverified_context
import urllib.request as req
import csv

with open("ijsrdoi.csv", mode="a", newline='') as ijsr_doi:
    writer = csv.writer(ijsr_doi)
    # writer.writerow(["pName", "doi"])
    vol = 3
    year = 2011
    while year >= 2009:

        writer.writerow(["Vol"+str(vol)+"_"+str(year)])
        
        i=1
        while i<=4:
            url = "https://link.springer.com/journal/12369/volumes-and-issues/"+str(vol)+"-"+str(i)
            request = req.Request(url, headers={"user-agent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.130 Safari/537.36"})
            with req.urlopen(request) as response:
                paper = response.read()
            soup = BeautifulSoup(paper, "html.parser")
            titles = soup.find_all("h3", {"class": "c-card__title"})
            for title in titles:
                    writer.writerow([title.select_one("a").text,title.select_one("a").get("href").split("/",4)[4]])
            i+=1
        
        year -= 1
        vol -= 1
