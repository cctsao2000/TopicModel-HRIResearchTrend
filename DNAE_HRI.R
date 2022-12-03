library(tm)
library(dplyr)

# Check working directory
if (getwd() != "/home/chanhsu08/researches/hci_topic_model") setwd("/home/chanhsu08/researches/hci_topic_model")

source("R/conda_TF1_setting.R")
source("R/find_topic.R")
source("R/load_dtm.R")
source("R/topic_dist.R")

# Load Data
dtm <- readRDS("data/r_objects/hri_dtm_1130.rds")
dtm <- as.matrix(dtm)
hri_meta <- read.csv("data/hri_paper_list.csv")
hri_meta$document <- as.character(hri_meta$document)

table(hri_meta$year)
# 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019 2020 2021 
#   26   34   34   26   30   42   50   55   49   53   66   42 
sum(table(hri_meta$year)) # 507

# Check if all paper has "year"
table(hri_meta$year[hri_meta$document %in% rownames(dtm)])
# 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019 2020 2021 
#   24   30   31   25   27   39   47   49   45   46   59   38 
sum(table(hri_meta$year[hri_meta$document %in% rownames(dtm)])) # 460, Not confirmed

# 110 papers in 2010-2013
# Use first 6 year to initialize weights
sum(hri_meta$year[hri_meta$document %in% rownames(dtm)] %in% 2010:2013)


# RMSE
rmse <- function(y_true, y_pred) {
  return(k_sqrt(k_mean(k_square(y_true - y_pred))))
}

# Nonnegative AutoEncoder
model <- keras_model_sequential() %>%
  layer_dense(name = "L1", units = 16,
              # kernel_regularizer = regularizer_l1_l2(l1 = 10e-7, l2 = 10e-7),
              kernel_constraint = constraint_nonneg(), input_shape = ncol(dtm), use_bias = F) %>%
  layer_dense(name = "L2", units = 8,
              # kernel_regularizer = regularizer_l1_l2(l1 = 10e-7, l2 = 10e-7),
              kernel_constraint = constraint_nonneg(), use_bias = F) %>%
  layer_dense(name = "L3", units = 16,
              # kernel_regularizer = regularizer_l1_l2(l1 = 10e-7, l2 = 10e-7),
              kernel_constraint = constraint_nonneg(), use_bias = F) %>%
  layer_dense(name = "L_out", units = ncol(dtm),
              # kernel_regularizer = regularizer_l1_l2(l1 = 10e-7, l2 = 10e-7),
              kernel_constraint = constraint_nonneg(), use_bias = F)

# Use rmse as loss function
model %>% compile(
  loss = rmse,
  optimizer = optimizer_adam(learning_rate = 0.001)
)

# Topic Evolution
topic_evo <- list()

# partition to 6 segments, 2010-2011, 2012-2013, 2014-2015, 2016-2017, 2018-2019, 2020-2021


for(y in c(1:5)) {
  print(paste0(2011 + 2*y))
  
  # Slice dtm by year
  if (y == 1) {
    # 2010 ~ 2013 for setting weight
    train_dtm <- dtm[rownames(dtm) %in% hri_meta[hri_meta$year %in% 2010:(2011 + 2*y), "document"], ]
  } else {
    # 2012 ~ 2021 segment to 5 section, input with sliding window = 2 (i.e. the previous + recent)
    train_dtm <- dtm[rownames(dtm) %in% hri_meta[hri_meta$year %in% (2011 + 2*(y - 1) -1):(2011 + 2*y), "document"], ]
  }
  
  # For online learning, we don't remove terms with frequency = 0
  train_dtm <- train_dtm[rowSums(train_dtm) > 0,]
  # Do tf-idf by slices
  train_dtm <- tf_idf(dtm = train_dtm)
  
  # Run autoencoder with early stopping and patience epoch = 200
  model %>% fit(
    x = train_dtm, 
    y = train_dtm, 
    epochs = 300, 
    batch_size = 8,
    view_metrics = F,
    callbacks = list(callback_early_stopping(monitor = "loss", patience = 200))
  )
  
  # Create directory to save trained models
  # if (!dir.exists(path = "online_models")) {
  #   dir.create(path = "online_models")
  # }
  
  # Save model for each year
  # save_model_hdf5(object = model, filepath = paste0("online_models/model", y))
  
  # Compute the Frobenius norm for input dtm
  original_norm <- norm(train_dtm, type = "F")
  
  # Recovery Frobenius norm
  pred_norm <- norm(train_dtm - predict(model, train_dtm), type = "F")
  
  # RMSE
  RMSE <- sqrt(mean((train_dtm - predict(model, train_dtm)) ^ 2))
  
  # Get weight from Keras model
  w <- get_weights(model)
  
  # Build topic-term matrix
  topic_term <- w[[1]] %*% w[[2]]
  # Normalize for each colSum = 1
  # But this normalized matrix is not used in results since term diffusion will normalize again
  tt <- t(solve(diag(colSums(topic_term))) %*% t(topic_term))
  rownames(topic_term) <- colnames(train_dtm)
  colnames(topic_term) <- paste0(2010 + y, "_topic_", 1:ncol(topic_term))
  topic_term <- ifelse(topic_term <= .Machine$double.eps, 0, topic_term)
  
  # Subtopic weight of each topic
  subtopic_weight <- w[[2]]
  
  # Build subtopic-topic matrix
  subtopic_term <- w[[1]]
  # Normalize for each colSum = 1
  # But this normalized matrix is not used in results since term diffusion will normalize again
  st <- t(solve(diag(colSums(subtopic_term))) %*% t(subtopic_term))
  rownames(subtopic_term) <- colnames(train_dtm)
  colnames(subtopic_term) <- paste0(2010 + y, "_sub_topic_", 1:ncol(subtopic_term))
  subtopic_term <- ifelse(subtopic_term <= .Machine$double.eps, 0, subtopic_term)
  
  topic_evo[[y]] <- list("topic_term" = topic_term,
                         "subtopic_term" = subtopic_term,
                         "subtopic_weight" = subtopic_weight,
                         "original_norm" = original_norm,
                         "pred_norm" = pred_norm,
                         "RMSE" = RMSE)
}

save(topic_evo, file = "models/hri_nae_1201_v1.RData")

# Generate top-10 term table
top10_terms <- lapply(topic_evo, function(x) {
  top10_terms <- find_topic(x$topic_term, 10)$term
  top10_terms <- apply(top10_terms, 2, function(x) paste0(x, collapse = ",\n"))
})
top10_terms <- do.call(what = cbind, args = top10_terms)
colnames(top10_terms) <- c("2012-2013", "2014-2015", "2016-2017", "2018-2019", "2020-2021")
write.csv(top10_terms, file = "data/results_1201/top_10_terms.csv")

# Generate top-5 term table
top5_terms <- lapply(topic_evo, function(x) {
  top5_terms <- find_topic(x$topic_term, 5)$term
  top5_terms <- apply(top5_terms, 2, function(x) paste0(x, collapse = ",\n"))
})
top5_terms <- do.call(what = cbind, args = top5_terms)
# colnames(top5_terms) <- 2015:2021
colnames(top5_terms) <- c("2012-2013", "2014-2015", "2016-2017", "2018-2019", "2020-2021")
write.csv(top5_terms, file = "data/results_1201/top_5_terms.csv")

# Generate top-1 term table
top5_terms <- lapply(topic_evo, function(x) {
  top5_terms <- find_topic(x$topic_term, 1)$term
  top5_terms <- apply(top5_terms, 2, function(x) paste0(x, collapse = ",\n"))
})
top5_terms <- do.call(what = cbind, args = top5_terms)
# colnames(top5_terms) <- 2015:2021
colnames(top5_terms) <- c("2012-2013", "2014-2015", "2016-2017", "2018-2019", "2020-2021")
write.csv(top5_terms, file = "data/results_1201/top_1_terms.csv")

# Ranking of subtopics in each topic
topics_subtopics <- lapply(seq_along(topic_evo), function(i){
  topics <- topic_evo[[i]]$subtopic_weight
  topics <- apply(topics, 2, function(x) {
    topic_order <- order(x, decreasing = T)[1:3]
    x <- x[order(x, decreasing = T)][1:3]
    topic_order <- topic_order[x > 0]
    return(paste(round(x[x > 0], digits = 2), "Subtopic", topic_order, collapse = ",\n"))
  })
})
topics_subtopics <- do.call(what = cbind, args = topics_subtopics)
rownames(topics_subtopics) <- paste("Topic", seq(8))
# colnames(topics_subtopics) <- 2015:2021
colnames(topics_subtopics) <- c("2012-2013", "2014-2015", "2016-2017", "2018-2019", "2020-2021")
write.csv(topics_subtopics, file = "data/results_1201/top3_subtopics.csv")

