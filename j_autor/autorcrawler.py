from bs4 import BeautifulSoup
import ssl
ssl._create_default_https_context = ssl._create_unverified_context
import urllib.request as req
import csv

with open("autordoi.csv", mode="a", newline='') as autor_doi:
    writer = csv.writer(autor_doi)
    # writer.writerow(["pName", "doi"])
    vol = 21
    year = 2006
    while vol >= 20:

        writer.writerow(["Vol"+str(vol)+"_"+str(year)])
        
        i=1
        while i<=3:
            url = "https://link.springer.com/journal/10514/volumes-and-issues/"+str(vol)+"-"+str(i)
            request = req.Request(url, headers={"user-agent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.130 Safari/537.36"})
            with req.urlopen(request) as response:
                paper = response.read()
            soup = BeautifulSoup(paper, "html.parser")
            titles = soup.find_all("h3", {"class": "c-card__title"})
            for title in titles:
                    writer.writerow([title.select_one("a").text,title.select_one("a").get("href").split("/",4)[4]])
            i+=1
        
        # year -= 1
        vol -= 1
