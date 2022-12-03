#' @title Create DTM with HRI
#' @author Chan Hsu
#' Nov 23, 2021

library(tidytext)
library(dplyr)
library(tm)

# Check working directory
if (getwd() != "/home/chanhsu08/researches/hci_topic_model") setwd("/home/chanhsu08/researches/hci_topic_model")

##### Load text files to data frame #####
root_dir <- "data/txt_files/hritxt"

sub_dirs <- sub_dirs <- setdiff(list.dirs(root_dir, full.names = T), 
                                c(root_dir, paste0(root_dir, "/.ipynb_checkpoints")))


corpus_list <- lapply(sub_dirs, function(directory){
  
  
  # Return a list of text of papers
  text_list <- lapply(list.files(directory, full.names = T), 
                      function(file_path){
                        content <- readChar(file_path, file.info(file_path)$size)
                        return(paste(content, sep = " "))
                      })
  # Create a character vector of file names
  file_names <- gsub(directory, "", list.files(directory, full.names = T))
  file_names <- gsub("/", "", file_names)
  file_names <- gsub(".txt", "", file_names)
  
  corpus_df <- data.frame(matrix(unlist(text_list), nrow=length(text_list), byrow=TRUE))
  corpus_df$document <- file_names
  corpus_df$year <- gsub("[^0-9]", "", directory)
  corpus_df$text <- apply(corpus_df , 1 , paste , collapse = " " )
  corpus_df <- corpus_df[tail(names(corpus_df), 3)]
})

hri_df <- bind_rows(corpus_list)

hri_paper_per_year <- hri_df[, -3]
# write.csv(hri_paper_per_year, "data/hri_paper_list.csv", row.names = F)

##### Tokenizing with ngrams #####

# Load dictionary
dict_low <- read.csv("data/dict_low_1130.txt", header = F, col.names = "keyword")
dict_abbr <- read.csv("data/dict_abbr_1123.txt", header = F, col.names = "keywrod")

# Start from fourgram, and remove words which has been counted

### Four-gram
# filter w/ dict_low    462
hri_low_fourgram <- hri_df %>% 
  unnest_tokens(word, text, token = "ngrams", n = 4) %>% 
  filter(word %in% dict_low$keyword)

# filter w/ dict_abbr   0
hri_abbr_fourgram <- hri_df %>%
  unnest_tokens(word, text, token = "ngrams", n = 4) %>%
  filter(word %in% dict_abbr$keywrod)

# remove counted words
nrow(hri_low_fourgram); nrow(hri_abbr_fourgram)
hri_df$text <- gsub(paste0("(", paste(unique(hri_low_fourgram$word), collapse = "|"), ")"), "", hri_df$text)

### Trigram
# filter w/ dict_low 7949
hri_low_trigram <- hri_df %>% 
  unnest_tokens(word, text, token = "ngrams", n = 3) %>% 
  filter(word %in% dict_low$keyword)

# filter w/ dict_abbr   0
hri_abbr_trigram <- hri_df %>%
  unnest_tokens(word, text, token = "ngrams", n = 3) %>%
  filter(word %in% dict_abbr$keywrod)

nrow(hri_low_trigram); nrow(hri_abbr_trigram)
length(unique(hri_low_trigram$word))
hri_df$text <- gsub(paste0("(", paste(unique(hri_low_trigram$word), collapse = "|"), ")"), "", hri_df$text)

### Bigram
# filter w/ dict_low 50914
hri_low_bigram <- hri_df %>% 
  unnest_tokens(word, text, token = "ngrams", n = 2) %>% 
  filter(word %in% dict_low$keyword)

# filter w/ dict_abbr   0
hri_abbr_bigram <- hri_df %>%
  unnest_tokens(word, text, token = "ngrams", n = 2) %>%
  filter(word %in% dict_abbr$keywrod)

nrow(hri_low_bigram); nrow(hri_abbr_bigram)
length(unique(hri_low_bigram$word))
# Limited by the max length of regular expression, we have to seperate to 4 steps
hri_df$text <- gsub(paste0("(", paste(unique(hri_low_bigram$word)[1:500], collapse = "|"), ")"), "", hri_df$text)
hri_df$text <- gsub(paste0("(", paste(unique(hri_low_bigram$word)[501:1000], collapse = "|"), ")"), "", hri_df$text)
hri_df$text <- gsub(paste0("(", paste(unique(hri_low_bigram$word)[1001:1500], collapse = "|"), ")"), "", hri_df$text)
hri_df$text <- gsub(paste0("(", paste(unique(hri_low_bigram$word)[1501:2141], collapse = "|"), ")"), "", hri_df$text)

### Unigram

# filter w/ dict_low    437706
hri_low_unigram <- hri_df %>% 
  unnest_tokens(word, text) %>%
  filter(word %in% dict_low$keyword)

# filter w/ dict_abbr   0
hri_abbr_unigram <- hri_df %>%
  unnest_tokens(word, text) %>%
  filter(word %in% dict_abbr$keywrod)

nrow(hri_low_unigram); nrow(hri_abbr_unigram)

# ### Bigram
# # filter w/ dict_low 51820
# hri_low_bigram <- hri_df %>% 
#   unnest_tokens(word, text, token = "ngrams", n = 2) %>% 
#   filter(word %in% dict_low$keyword)
# 
# # filter w/ dict_abbr   0
# hri_abbr_bigram <- hri_df %>%
#   unnest_tokens(word, text, token = "ngrams", n = 2) %>%
#   filter(word %in% dict_abbr$keywrod)
# 
# nrow(hri_low_bigram); nrow(hri_abbr_bigram)
# 
# ### Trigram
# # filter w/ dict_low 8018
# hri_low_trigram <- hri_df %>% 
#   unnest_tokens(word, text, token = "ngrams", n = 3) %>% 
#   filter(word %in% dict_low$keyword)
# 
# # filter w/ dict_abbr   0
# hri_abbr_trigram <- hri_df %>%
#   unnest_tokens(word, text, token = "ngrams", n = 3) %>%
#   filter(word %in% dict_abbr$keywrod)
# 
# nrow(hri_low_trigram); nrow(hri_abbr_trigram)
# unique(hri_low_trigram$word)

### Five-gram
# # filter w/ dict_low    2 -> was it wrong?
# hri_low_fivegram <- hri_df %>% 
#   unnest_tokens(word, text, token = "ngrams", n = 5) %>% 
#   filter(word %in% dict_low$keyword)
# 
# # filter w/ dict_abbr   0
# hri_abbr_fivegram <- hri_df %>%
#   unnest_tokens(word, text, token = "ngrams", n = 5) %>%
#   filter(word %in% dict_abbr$keywrod)

# nrow(hri_low_fivegram); nrow(hri_abbr_fivegram)

### Count and cast to DTM
hri_low_count <- bind_rows(hri_low_unigram, hri_low_bigram, hri_low_trigram, hri_low_fourgram)

# merge similar words
hri_low_count$word <- gsub("(social human robot interaction | human and robot interaction | physical human robot interaction | 
                              adaptive human robot interaction)", 
                              "human robot interaction", hri_low_count$word)

hri_low_count$word <- gsub("(wilderness search and rescue | urban search and rescue)", 
                           "search and rescue", hri_low_count$word)

hri_low_count$word <- gsub("(socially assistive robots | socially assistive robotics)", 
                           "", hri_low_count$word)

# lemmatization
hri_low_count$word <- gsub("(markov decision processes)", "markov decision process", hri_low_count$word)
hri_low_count$word <- gsub("behaviors", "behavior", hri_low_count$word)
hri_low_count$word <- gsub("autism spectrum disorders", "autism spectrum disorder", hri_low_count$word)



hri_dtm <- hri_low_count %>%
  group_by(document) %>%
  count(word)

# We have to tidy tf datarframe
hri_dtm <- hri_dtm %>%
  cast_dtm(document, word, n)

saveRDS(hri_dtm, "data/r_objects/hri_dtm_1130.rds")

as.matrix(hri_dtm)[1:10, 1:20]
##### testing code #####
# year <- gsub("[^0-9]", "", sub_dirs[1])
# text_list <- lapply(list.files(sub_dirs[1], full.names = T),
#                     function(file_path){
#                       content <- readChar(file_path, file.info(file_path)$size)
#                       return(content)
#                     })
# # test <- readChar("data/txt_files/hritxt/2010_HRI/1734454.1734580.txt", 
# #                  file.info("data/txt_files/hritxt/2010_HRI/1734454.1734580.txt")$size)
# file_names <- gsub(sub_dirs[1], "", list.files(sub_dirs[1], full.names = T))
# file_names <- gsub("/", "", file_names)
# file_names <- gsub(".txt", "", file_names)
# 
# corpus_df <- data.frame(matrix(unlist(text_list), nrow=length(text_list), byrow=TRUE))
# row.names(corpus_df) <- file_names
# 
# corpus_df$year <- gsub("[^0-9]", "", sub_dirs[1])
# corpus_df$text <- apply(corpus_df , 1 , paste , collapse = " " )
# corpus_df <- corpus_df[tail(names(corpus_df), 2)]



