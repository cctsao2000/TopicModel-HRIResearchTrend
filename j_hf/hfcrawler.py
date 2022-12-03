from bs4 import BeautifulSoup
import ssl
ssl._create_default_https_context = ssl._create_unverified_context
import urllib.request as req
import csv

with open("hfdoi.csv", mode="a", newline='') as hf_doi:
    writer = csv.writer(hf_doi)
    # writer.writerow(["pName", "doi"])

    vol = 48
    year = 2006
    while year >= 2006:

        writer.writerow(["Vol"+str(vol)+"_"+str(year)])
        
        i=1
        while i <= 4:
            url = "https://journals.sagepub.com/toc/hfsa/"+str(vol)+"/"+str(i)
            request = req.Request(url, headers={"user-agent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.130 Safari/537.36", "cookie":"accept-cookie-policy=1"})
            with req.urlopen(request) as response:
                paper = response.read()
            soup = BeautifulSoup(paper, "html.parser")
            # print(soup)
            titles = soup.find_all("div", {"class": "art_title linkable"})
            for title in titles:
                writer.writerow([title.select_one("span").text,title.select_one("a").get("href").split("/",3)[3]])
            i+=1
        
        year -= 1
        vol -= 1
