with open("4dict_low_.txt", mode="w") as fixed:
    setdict = set()
    with open("4dict_low.txt", mode="r") as org:
        lines = org.readlines() 
        count = -1
        while (count < 9397):
            count+=1
            k = lines[count]
            if(lines[count-1][:-1] == k[:-2] and k[-2] == " "):
                continue
            # elif(lines[count-1][:-1] == k[:-2] and k[-2] == "s"):
            #     continue
            setdict.add(k)
    dict = sorted(list(setdict))
    for w in dict:
        fixed.write(w)           