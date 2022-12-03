import os
import re
volume = 1
year = 2009

txtfolders = os.listdir("ijsrtxt")
if '.DS_Store' in txtfolders:
    txtfolders.remove('.DS_Store')
keys = []
rks = []
for folder in txtfolders:
    txtFile = os.listdir("ijsrtxt/"+folder)
    if '.DS_Store' in txtFile:
        txtFile.remove('.DS_Store')
    abbr = ["1 Introduction","A.","B.","C.","D.","E.","F.","G.","H.","I.","J.","K.","L.","M.","N.","O.","P.","Q.","R.","S.","T.","U.","V.","W.","X.","Y.","Z."]
    for file in txtFile:
        with open("ijsrtxt/"+folder+"/"+file, mode="r") as content:
            c = content.read()
            start = c.find("Keywords")
            end = c.find("1  Introduction")
            part = c[start+10:end]
            for a in abbr:
                if (part.find(a) != -1):
                    part = part[:part.find(a)]
            nkey = re.split(r'   | · |·|\n\n',part)
            for n in nkey:
                rk = n.replace("\n", " ")
                try:
                    if(rk[0] == " "):
                        rk = rk[1:]
                    rks.append(rk)
                except IndexError:
                    continue
            keys = list(set(keys+rks))
sk = sorted(keys)
with open("ijsr_dict", mode="w") as dic:
    for word in sk:
        dic.write(word+"\n")
