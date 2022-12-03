import os
import re

txtfolders = os.listdir("tochitxt")
if '.DS_Store' in txtfolders:
    txtfolders.remove('.DS_Store')
keys = []
rks = []
for folder in txtfolders:
    txtFile = os.listdir("tochitxt/"+folder)
    if '.DS_Store' in txtFile:
        txtFile.remove('.DS_Store')
    startwords = ["General Terms","Additional Key Words and Phrases"]
    endwords = ["ACM Reference Format","1. ","INTRODUCTION","Introduction","\n\n"]
    earlyend = ["ACM ","•","©","@","Â","â","â",'\"']
    for file in txtFile:
        with open("tochitxt/"+folder+"/"+file, mode="r") as content:
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
            part = c[start:end]
            for a in earlyend:
                if (part.find(a) != -1):
                    part = part[:part.find(a)]
            nkey = re.split(r',|;|Additional Key Words and Phrases',part)
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
with open("tochi_all_dict.txt", mode="w") as dic:
    for word in sk:
        dic.write(word+"\n")
