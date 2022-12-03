from bs4 import BeautifulSoup
import ssl
ssl._create_default_https_context = ssl._create_unverified_context
import urllib.request as req
import csv

with open("srdoi.csv", mode="a", newline='') as sr_doi:
    writer = csv.writer(sr_doi)
    # writer.writerow(["pName", "doi"])
    i = 1
    vol = 1
    year = 2016

    writer.writerow(["Vol"+str(vol)+"_"+str(year)])

    while i>=1:
        url = "https://robotics.sciencemag.org/content/"+str(vol)+"/"+str(i)
        request = req.Request(url, headers={"user-agent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.130 Safari/537.36", "cookie":"accept-cookie-policy=1"})
        with req.urlopen(request) as response:
            paper = response.read()
        soup = BeautifulSoup(paper, "html.parser")
        # print(soup)
        titles = soup.find_all("div", {"class": "media__body"})
        for title in titles:
            writer.writerow([title.select_one("div").text,"10.1126/scirobotics."+title.select_one("a").get("href").split("/",4)[4].split("e",1)[1]])
        i-=1
