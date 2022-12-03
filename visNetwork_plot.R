# library(data.table)
library(visNetwork)
library(magrittr)
## Choose Topic 
source("R/Create_visNetwork.R")
choose_topic = 8
test <- lapply(1:5, function(x)topic_evo[[x]][['topic_term']][,choose_topic])
test %<>% do.call(cbind, .)

# Get top 20 term in each topic of year.
t_top20 <- find_topic(test,10)
t_top20$term <- gsub(pattern = " ", replacement = "\n", x = t_top20$term)
# colnames(t_top20$term) = paste0(2010+1:ncol(test),"\n", "Topic ", choose_topic)
colnames(t_top20$term) <- paste(c('2012 \n Topic ',
                                  '2014 \n Topic ',
                                  '2016 \n Topic ',
                                  '2018 \n Topic ',
                                  '2020 \n Topic '),choose_topic)
# colnames(t_top20$value) = paste0(2010+1:ncol(test),"\n", "Topic ", choose_topic)
colnames(t_top20$value)<- paste(c('2012 \n Topic ',
                                  '2014 \n Topic ',
                                  '2016 \n Topic ',
                                  '2018 \n Topic ',
                                  '2020 \n Topic '),choose_topic)

edge = edge_function(t_top20$term,t_top20$value) # 主題與詞之間的關係
node = node_function(edge)

# 繪製年度主題網路圖
visNetwork(node, edge, width = "1500px", height = "1500px") %>%
  visEdges(length = 2) %>% 
  visIgraphLayout() %>%
  visEvents(type = "once", startStabilizing = "function() {
            this.moveTo({scale:0.1})}") %>%
  visPhysics(stabilization = TRUE) %>%
  visNodes(color = list(background = "lightblue",
                        border = "darkblue",
                        highlight = "yellow"),
           shadow = list(enabled = F, size = 10))  %>%
  visLayout(randomSeed = 22) %>% 
  visSave(file = "/home/chanhsu08/researches/hci_topic_model/visNetwork/topic_8_1201.html")
