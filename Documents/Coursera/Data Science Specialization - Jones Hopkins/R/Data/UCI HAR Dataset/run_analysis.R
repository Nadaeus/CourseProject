
###########  create script
#
library(plyr)
library(reshape)
# assumes that file is downloaded from link and unzipped to 
# current directory
setwd("~/UCI HAR Dataset/")

# read data from files in    ./UCI HAR dataset/" folder


trainSet    <- read.table("./train/X_train.txt")
trainLabel  <- read.table("./train/y_train.txt")
trainSubject    <- read.table("./train/subject_train.txt")

testSet     <- read.table("./test/X_test.txt")
testLabel   <- read.table("./test/y_test.txt") 
testSubject     <- read.table("./test/subject_test.txt")

activityLabel <- read.table("./activity_labels.txt", sep = " " )
feature <- read.table("./features.txt", header = F)

# change headers into meaningful names
colnames(feature) <- c("featureID", "featureName")
colnames(activityLabel) <- c("activity_ID", "activityName")

colnames(trainLabel)  <- c("activity_ID")
colnames(testLabel)  <- c("activity_ID")
colnames(trainSubject) <- c("subject_ID")
colnames(testSubject) <- c("subject_ID")
colnames(testSet) <- feature$featureName
colnames(trainSet) <- feature$featureName

# add activity and subject columns to datasets
trainSet_cbind <- cbind(trainLabel, trainSubject, trainSet)
testSet_cbind <-  cbind(testLabel, testSubject, testSet)

# add descriptive activity name column to datasets
trainSet_merged <- merge(activityLabel, trainSet_cbind, by = "activity_ID")
testSet_merged <- merge(activityLabel, testSet_cbind, by = "activity_ID")

# merge training and test datasets

testTrainSet_merged <- rbind(trainSet_merged, testSet_merged)




# Extract measurements on mean and standard deviation for each measurement.
# 

# 
x <- names(testTrainSet_merged)
mean_std_columns <-  x[grep("activity_ID|activityName|subject_ID|mean|std", x)]
testTrainSet_subset <- testTrainSet_merged[, mean_std_columns]

## write the final tidy dataset to file

write.table(testTrainSet_subset, file = "./TidyMergedSet.txt", row.names = F)

######### the codebook.md
# labels the data set with descriptive variable names. 
# 
########## the README.md
# 
########## create or use github repo and upload the files


