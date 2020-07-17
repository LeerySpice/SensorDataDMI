library(lattice)
library(ggplot2)
library(caret)
library(e1071)
library(kernlab)
library(randomForest)

df <- readRDS("Data/dfcluster.Rda")
for (x in 1:4) {
  assign(paste0("i",x), which(df$km.res.cluster==x))
  assign(paste0("ic",x), df[get(paste0("i",x)),][sample(1:length(df[get(paste0("i",x)),1]),min(table(df$km.res.cluster))),])
}

DB <- rbind(ic1,ic2, ic3, ic4)


# 80% TRAINING, 20% VALIDATION
validation_index <- createDataPartition(DB$km.res.cluster, p=0.80, list=FALSE)
validation <- DB[-validation_index,]
dataset <- DB[validation_index,]

dim(dataset)
sapply(dataset, class)
levels(dataset$km.res.cluster)
percentage <- prop.table(table(dataset$km.res.cluster)) * 100
cbind(freq=table(dataset$km.res.cluster), percentage=percentage)


# split input and output
x <- dataset[,1:96]
y <- dataset[,97]

# par(mfrow=c(1,1))
# for(i in 1:7) {
#   boxplot(x[,i], main=names(DB)[i])
# }

# featurePlot(x=x, y=y, plot="ellipse")

control <- trainControl(method="cv", number=10)
metric <- "Accuracy"

set.seed(7)
fit.lda <- train(km.res.cluster~., data=dataset, method="lda", metric=metric, trControl=control)
# b) nonlinear algorithms
# CART
set.seed(7)
fit.cart <- train(km.res.cluster~., data=dataset, method="rpart", metric=metric, trControl=control)
# kNN
set.seed(7)
fit.knn <- train(km.res.cluster~., data=dataset, method="knn", metric=metric, trControl=control)
# c) advanced algorithms
# SVM
set.seed(7)
fit.svm <- train(km.res.cluster~., data=dataset, method="svmRadial", metric=metric, trControl=control)
# Random Forest
set.seed(7)
fit.rf <- train(km.res.cluster~., data=dataset, method="rf", metric=metric, trControl=control)

results <- resamples(list(lda=fit.lda, cart=fit.cart, knn=fit.knn, svm=fit.svm, rf=fit.rf))
summary(results)

print(fit.rf)

predictions <- predict(fit.lda, validation)
confusionMatrix(predictions, validation$km.res.cluster)
