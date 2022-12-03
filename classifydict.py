with open("ARS/ars_low_dict.txt", mode="w") as low, open("ARS/ars_abbr_dict.txt", mode="w") as abbr:
    with open("ARS/ars_all_dict.txt", mode="r") as dictread:
        lines = dictread.readlines() 
        count = -1
        lowdict = set()
        abbrdict = set()
        while (count < 6650):
            count+=1
            if (lines[count].isupper()):
                abbrdict.add(lines[count])
            else:
                lower = lines[count].lower()
                lowdict.add(lower)  
    ldict = sorted(list(lowdict)) 
    adict = sorted(list(abbrdict))
    for l in ldict:
        low.write(l)
    for a in adict:
        abbr.write(a)
