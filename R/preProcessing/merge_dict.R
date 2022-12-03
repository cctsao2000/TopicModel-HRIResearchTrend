#' Combine dictionary of TOCHI, IJARS, Autonomous Robots, Human Factors, HRI and IJSR
#' each file includes keywords of papers from 2010 to 2021

### check working directory
if(getwd() != "/home/chanhsu08/researches/hci_topic_model/") setwd("/home/chanhsu08/researches/hci_topic_model/")

##### Load in dictionaries #####

# HRI
dict_hri_abbr <- as.data.frame(read.csv("c_hri/HRI_dic_abbr.txt", sep = "\n", header = F)) # 20
dict_hri_low <- as.data.frame(read.csv("c_hri/HRI_dic_low.txt", sep = "\n", header = F)) # 1157

# IJSR
dict_ijsr_abbr <- as.data.frame(read.csv("j_ijsr/ijsr_abbr_dic.txt", sep = "\n", header = F)) #25
dict_ijsr_low <- as.data.frame(read.csv("j_ijsr/ijsr_low_dic.txt", sep = "\n", header = F)) # 1650

# ARS, Auto Robot, Human Factor, TOCHI
dict_4journal_abbr <- as.data.frame(read.csv("4dict/4dict_abbr.txt", sep = "\n", header = F)) #221
dict_4journal_low <- as.data.frame(read.csv("4dict/4dict_low.txt", sep = "\n", header = F)) # 9197

##### aggregate and output #####
# aggregate dictionaries
output_dict_abbr <- rbind(dict_4journal_abbr, dict_hri_abbr, dict_ijsr_abbr) # 266
output_dict_abbr <- unique(output_dict_abbr) # 255
output_dict_low <- rbind(dict_4journal_low, dict_hri_low, dict_ijsr_low) # 12004
output_dict_low <- unique(output_dict_low) # 11245

# Save as .txt
abbr_txt <- file("data/dict_abbr_1123.txt")
writeLines(output_dict_abbr$V1, abbr_txt, sep = "\n")

low_txt <- file("data/dict_low_1123.txt")
writeLines(output_dict_low$V1, low_txt, sep = "\n")
