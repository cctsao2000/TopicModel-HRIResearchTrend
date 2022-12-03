#############################
# pdf2txt
# 1. 把 HRI 論文 pdf 檔轉成 txt 
# 2. 將 text 存成 txt 檔
#############################

library(pdftools)
# library(doMC) # parallel
library(stringr)

# Check working directory
if (getwd() != "/Users/chanhsu/D3Lab/hci_topic_model/") setwd("/Users/chanhsu/D3Lab/hci_topic_model/")

# set root path of the journal / conference
root_dir <- "/Users/chanhsu/D3Lab/HCI_data/paper_pdf/hripdf/pdf"

text_dir <- "/Users/chanhsu/D3Lab/HCI_data/paper_txt/hcitxt"

# return sub-directories as a list
sub_dirs <- setdiff(list.dirs(root_dir, full.names = T), 
                    c(root_dir, paste0(root_dir, "/.ipynb_checkpoints")))

# record how many papers had been download from the journal/conference
sizeOfPapers <- 0
list.files(sub_dirs[1], full.names = T)
# no_keywords_count <- 0

for (directory in sub_dirs) {
  
  file_list <- list.files(directory, full.names = T)
  sizeOfPapers <- length(file_list) + sizeOfPapers
  cat(directory, " : ", length(file_list), "\n")
  
  new_txt_dir <- gsub("paper_pdf/hripdf/pdf", "paper_txt/hritxt", directory)
  cat(new_txt_dir, "\n")
  
  lapply(file_list, function(file){
    list_output <- pdftools::pdf_text(file)
    text_output <- gsub('(\\s|\r|\n)+',' ',paste(unlist(list_output),collapse=" "))
    
    file_name <- gsub(directory, "", file)
    file_name <- gsub("pdf", "txt", file_name)
    file_name <- paste0(new_txt_dir, file_name)
    cat(file_name, "\n")
    output_file <- file(file_name)
    writeLines(text_output, output_file)
  })
}
