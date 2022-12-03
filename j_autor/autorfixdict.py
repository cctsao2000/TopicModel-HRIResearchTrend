import re
with open("autor_all_dict_.txt", mode="w") as fixed:
    with open("autor_all_dict.txt", mode="r") as org:
        lines = org.readlines() 
        count = -1
        setdict = set()
        while (count < 2106):
            count+=1
            k = lines[count]
            k = k.replace("  "," ")
            setdict.add(k)
    dict = sorted(list(setdict))
    for w in dict:
        fixed.write(w)           