import os
import re
volume = 52
year = 2010
# 2010 開始才有keywords

txtfolders = os.listdir("hftxt")
if '.DS_Store' in txtfolders:
    txtfolders.remove('.DS_Store')
keys = []
rks = []
for folder in txtfolders:
    txtFile = os.listdir("hftxt/"+folder)
    if '.DS_Store' in txtFile:
        txtFile.remove('.DS_Store')
    abbr = ["Address"]
    for file in txtFile:
        with open("hftxt/"+folder+"/"+file, mode="r") as content:
            c = content.read()
            start = c.find("Keywords")
            end = c.find("INTRODUCTION")
            if(start == -1 ):
                print("keyword not found -- "+file)
                continue
            elif (end == -1):
                addr = c.find("Address")
                if (addr != -1):
                    end = addr
                else:
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
with open("hf_all_dict.txt", mode="w") as dic:
    for word in sk:
        dic.write(word+"\n")
