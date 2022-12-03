with open("ars_all_dict.txt", mode="w") as fixed:
    setdict = set()
    with open("ars_all_dict_.txt", mode="r") as org:
        lines = org.readlines() 
        count = -1
        while (count < 6650):
            count+=1
            k = lines[count]
            if(k[0] == " "):
                k = k[1:]
            if(k[len(k)-1] == " "):
                k = k[:-1]
            setdict.add(k)
    dict = sorted(list(setdict))
    for w in dict:
        fixed.write(w)           