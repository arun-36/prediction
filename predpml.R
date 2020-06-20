library(caret)
library(dplyr)
library(RCurl)
library(gridExtra)
library(corrplot)


training <- read.csv("data/pml-training.csv")
testing <- read.csv("data/pml-testing.csv")

dim(training)


