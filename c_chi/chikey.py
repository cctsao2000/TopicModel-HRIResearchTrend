import os
import re

txtfolders = os.listdir("chitxt")
if '.DS_Store' in txtfolders:
    txtfolders.remove('.DS_Store')
keys = []
rks = []
for folder in txtfolders:
    txtFile = os.listdir("chitxt/"+folder)
    if '.DS_Store' in txtFile:
        txtFile.remove('.DS_Store')
    startwords = ["Keywords","KEYWORDS"]
    endwords = ["ACM Classification Keywords","INTRODUCTION","Introduction"]
    earlyend = [".\n","Permission to make","ACM","1   ","©","@","Â","â","â"]
    for file in txtFile:
        with open("chitxt/"+folder+"/"+file, mode="r",encoding = "ISO-8859-1") as content:
            c = content.read()
            i = 0
            j = 0
            start = c.find(startwords[i])
            end = c.find(endwords[j])
            try:
                while(start == -1 ):
                    i += 1
                    start = c.find(startwords[i])
            except IndexError:
                    print("keyword not found -- "+file)
                    continue
            try:
                while(end == -1):
                    j += 1
                    end = c.find(endwords[j])
            except IndexError:
                print("intro not found -- "+file)
                continue
            part = c[start+9:end]
            for a in earlyend:
                if (part.find(a) != -1):
                    part = part[:part.find(a)]
            nkey = re.split(r',|;|.  | · |·|\n\n| · | . ',part)
            for n in nkey:
                rk = n.replace("\n", " ")
                ind = 0
                try:
                    while(rk[ind] == " "):
                        ind += 1
                    rk = rk[ind:]
                    rks.append(rk)
                except IndexError:
                    continue
            keys = list(set(keys+rks))
sk = sorted(keys)
with open("chi_all_dict.txt", mode="w") as dic:
    for word in sk:
        dic.write(word+"\n")