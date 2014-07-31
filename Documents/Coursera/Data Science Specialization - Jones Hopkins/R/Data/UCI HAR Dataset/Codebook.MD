
###  CodeBook ###



# The script assumes that file is downloaded from link and unzipped to 
# current directory, and it changes the working directory accordingly:
setwd("~/UCI HAR Dataset/")

# Steps:
# read data from files in    ./UCI HAR dataset/" folder


# read tables:
trainSet       from X_train dataframe
trainLabel     from /train/y_train.txt
trainSubject   from /ttrain/subject_train.txt

testSet        from  /test/X_test.txt
testLabel      from  test/y_test.txt
testSubject    from  /test/subject_test.txt

activityLabel  from  activity_labels.txt
feature        from features.txt

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

x <- names(testTrainSet_merged)
mean_std_columns <-  x[grep("activity_ID|activityName|subject_ID|mean\\(|std", x)]
testTrainSet_subset <- testTrainSet_merged[, mean_std_columns]

## aggregating the final dataset from testTrainSet_subset with only mean

final <- aggregate(testTrainSet_subset, by = list(testTrainSet_subset$subject_ID, 
          testTrainSet_subset$activity_ID, testTrainSet_subset$activityName) , FUN =mean) 

# maiking final adjustments (delete duplicate columns, adding activity_name column)
finalset <- final[, -c(1,2,5,6)]
colnames(finalset)[1] <- "activity_name"

- names(testTrainSet_merged)


## write the final tidy dataset to file

write.table(testTrainSet_subset, file = "./TidyMergedSet.txt", row.names = F)



