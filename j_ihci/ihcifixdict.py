with open("ihci_all_dict.txt", mode="w") as fixed:
    setdict = set()
    with open("ihci_all_dict_.txt", mode="r") as org:
        lines = org.readlines() 
        count = -1
        while (count < 67):
            count+=1
            k = lines[count]
            k = k.replace("- ","")
            while(k.find("  ") != -1):
                k = k.replace("  "," ")
            if(k[0] == " "):
                k = k[1:]
            if(k[len(k)-1] == " "):
                k = k.replace(k[len(k)-1],"")
            setdict.add(k)
    dict = sorted(list(setdict))
    for w in dict:
        fixed.write(w)           
