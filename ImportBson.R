install.packages("mongolite")
library(mongolite)
library(jsonlite)

BD <- mongo()
BD$import(file("Data/polin/measurements.bson"), bson = TRUE)
BD$export(file("Data/Data.json"))

data <- fromJSON(sprintf("[%s]", paste(readLines("Data/Data.json"), collapse=",")))
save(data,file="Data/data.Rda")