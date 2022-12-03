with open("cscw_all_dict_.txt", mode="w") as fixed:
    with open("cscw_all_dict.txt", mode="r") as org:
        lines = org.readlines() 
        count = -1
        setdict = set()
        while (count < 2812):
            count+=1
            k = lines[count]
            while(k.find(" ") == len(k)-1):
                k = k[:-1]
            setdict.add(k)
    dict = sorted(list(setdict))
    for w in dict:
        fixed.write(w)           