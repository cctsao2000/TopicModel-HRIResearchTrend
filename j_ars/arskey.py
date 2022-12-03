import os
import re
volume = 3
year = 2006

txtfolders = os.listdir("arstxt")
if '.DS_Store' in txtfolders:
    txtfolders.remove('.DS_Store')
keys = []
rks = []
for folder in txtfolders:
    txtFile = os.listdir("arstxt/"+folder)
    if '.DS_Store' in txtFile:
        txtFile.remove('.DS_Store')
    abbr = ["1.","Date received","List of symbols","doi","Brief","Nomenclature","www"]
    for file in txtFile:
        with open("arstxt/"+folder+"/"+file, mode="r") as content:
            c = content.read()
            start = c.find("Keywords")
            end = c.find("Introduction")
            if(start == -1 ):
                print("keyword not found -- "+file)
                continue
            elif (end == -1):
                print("intro not found -- "+file)
                continue
            else:
                part = c[start+9:end]
                for a in abbr:
                    if (part.find(a) != -1):
                        part = part[:part.find(a)]
                nkey = re.split(r',|;',part)
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
with open("ars_all_dict.txt", mode="w") as dic:
    for word in sk:
        dic.write(word+"\n")