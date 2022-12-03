with open("ijsr_dict_.txt", mode="w") as fixed:
    with open("ijsr_dict.txt", mode="r") as org:
        lines = org.readlines() 
        count = -1
        setdict = set()
        while (count < 1476):
            count+=1
            k = lines[count].lower()
            setdict.add(k)
    dict = sorted(list(setdict))
    for w in dict:
        fixed.write(w)           