library(caret)
library(dplyr)
library(RCurl)
library(gridExtra)
library(corrplot)

training <- read.csv("pml-training.csv")
testing <- read.csv("pml-testing.csv")

dim(training)

dim(testing)



removeMissingData <- sapply(testing, function (x) any(is.na(x) | x == ""))
definingPredictorVariables <- !removeMissingData & grepl("belt|[^(fore)]arm|dumbbell|forearm", names(removeMissingData))
PredictorVariables <- names(removeMissingData)[definingPredictorVariables]
PredictorVariables



onlyPredictors <- c("classe", PredictorVariables)
training <- training[, onlyPredictors]
dim(training)



nuFoldData <- 10
nuRepeats <- 3
testDataSize <- 0.7
base <- read.csv("data/pml-training.csv")
tempTraining <- createDataPartition(base$classe, p = testDataSize, list = FALSE)
training <- base[tempTraining,]
validation <- base[-tempTraining,]


tempTrControl <- trainControl(method = "repeatedcv", number = nuFoldData, repeats = nuRepeats)
trainedModel <- train(classe ~ ., data = training[,c("classe", "roll_belt","roll_arm", "roll_dumbbell", "roll_forearm", "pitch_belt", "pitch_arm", "pitch_dumbbell", "pitch_forearm", "yaw_belt", "yaw_arm", "yaw_dumbbell", "yaw_forearm")],
                      method = "rf", ntree = nuFoldData, trControl = tempTrControl)

confusionMatrix(trainedModel, newdata = predict(trainedModel, newdata = validation))




nuPredictions <- 20
finalData <- rep(NA, nuPredictions)
for(i in 1:nuPredictions){
  tmpID <- filter(testing, problem_id == i)
  finalData[i] <- as.vector(predict(trainedModel, newdata = tmpID))
}
finalData
