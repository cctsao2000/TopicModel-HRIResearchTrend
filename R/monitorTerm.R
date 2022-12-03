# source("R/myImagePlot.R")
source("R/termProbPlot.R")

# Monitoring a term 
monitorTerm <- function(term, periods, numOfPeriods, numOfTopics, p_term_topic_list){
  
  probVectors <- lapply(p_term_topic_list, function(x) x[term,])
  probVectors <- do.call(what = cbind, args = probVectors)
  probVectors <- t(solve(diag(colSums( probVectors))) %*% t( probVectors))
  
  GJSD <- sapply(seq(from = 2, to = numOfPeriods), function(i) {
    ykang::gjsdivergence(pVecs = probVectors[, 1:i])
  })
  
  # GJSD threshold
  GJSD_kt <- sapply(seq(from = 2, to = numOfPeriods), function(i) {
    ykang::expectedGJSD(alpha = 0.01,
                        N = i * numOfTopics,
                        k = numOfTopics,
                        m = i)
  })
  
  #dev.off()
  print(termProbPlot(probVectors, title = term, yLabels = paste("Topic", seq(numOfTopics)), xLabels = periods))
  return(list("probVectors" = probVectors,
              "GJSD" = GJSD,
              "GJSD_kt" = GJSD_kt))
}
