library(lattice)
library(ggplot2)
library(caret)
library(e1071)
library(kernlab)
library(randomForest)

df <- readRDS("Data/dfcluster.Rda")
validation_index <- createDataPartition(df$km.res.cluster, p=0.80, list=FALSE)
validation <- df[-validation_index,]
dataset <- df[validation_index,]

dim(dataset)
sapply(dataset, class)
levels(dataset$km.res.cluster)
percentage <- prop.table(table(dataset$km.res.cluster)) * 100
cbind(freq=table(dataset$km.res.cluster), percentage=percentage)

control <- trainControl(method="cv", number=10)
metric <- "Accuracy"

set.seed(7)
fit.lda <- train(km.res.cluster~., data=dataset, method="lda", metric=metric, trControl=control)
saveRDS(fit.lda, "Models/LDA_model.rds")
# nonlinear algorithms CART
set.seed(7)
fit.cart <- train(km.res.cluster~., data=dataset, method="rpart", metric=metric, trControl=control)
saveRDS(fit.cart, "Models/CART_model.rds")
# kNN
set.seed(7)
fit.knn <- train(km.res.cluster~., data=dataset, method="knn", metric=metric, trControl=control)
saveRDS(fit.knn, "Models/KNN_model.rds")
# advanced algorithms SVM
set.seed(7)
fit.svm <- train(km.res.cluster~., data=dataset, method="svmRadial", metric=metric, trControl=control)
saveRDS(fit.svm, "Models/SVM_model.rds")
# Random Forest
set.seed(7)
fit.rf <- train(km.res.cluster~., data=dataset, method="rf", metric=metric, trControl=control)
saveRDS(fit.rf, "Models/RF_model.rds")

results <- resamples(list(lda=fit.lda, cart=fit.cart, knn=fit.knn, svm=fit.svm, rf=fit.rf))
summary(results)
dotplot(results)

jpeg("Models/model_comparation.png", width = 800, height = 600)
dotplot(results)
dev.off()

print(fit.rf)

predictions <- predict(fit.rf, validation)
confusionMatrix(predictions, validation$km.res.cluster)
