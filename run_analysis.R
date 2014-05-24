##  Getting and Cleaning Data Course Project
##  Creating a tidy data set from the UCI HAR data
##  Requires packages "gdata", "reshape2"

## STEP ONE - Merges the training and the test sets to create one data set.

## Download data, unzip it and delete the zip folder

require(gdata)
require(reshape2)

get.data <- function (){
        if (!file.exists("data")) {
        message("Creating Data folder in working directory")
        dir.create("data")
        }
          
        if(!file.exists("data/UCI HAR Dataset")) {
        fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(fileURL, destfile = "./data/UCI_HAR_data.zip")
        file.name <- "./data/UCI_HAR_data.zip"
        unzip(file.name, exdir = "data")
        unlink(file.name)
}
else message("data already exists")
}

get.data()

## Read the measurement file

  features <- read.table("./data/UCI HAR Dataset/features.txt")

## Read the test data

  xtest <- read.table("./data/UCI HAR Dataset/test/x_test.txt", col.names = features[,2])
  ytest <- read.table("./data/UCI HAR Dataset/test/Y_test.txt", col.names = c("Activity_ID"))
  subtest <- read.table("./data/UCI HAR Dataset/test/subject_test.txt", col.names = c("Subject_ID"))

## Read the training data
  
  xtrain <- read.table("./data/UCI HAR Dataset/train/X_train.txt", col.names = features[,2])
  ytrain <- read.table("./data/UCI HAR Dataset/train/y_train.txt", col.names = c("Activity_ID"))
  subtrain <- read.table("./data/UCI HAR Dataset/train/subject_train.txt", col.names = c("Subject_ID"))

## Merge test and training data

  test <- cbind(xtest, ytest, subtest)
  train <- cbind(xtrain, ytrain, subtrain)
  combined.data <- rbind(test, train)
  head(combined.data, n = 5)


## STEP 2:  Extracts only the measurements on the mean and standard deviation for each measurement.

## Subset the combined data to only include measurement columns measuring mean or standard deviation

keycols <- matchcols(combined.data, with=c("mean", "std"), method = "or")
pretidy <- combined.data[,c("Activity_ID","Subject_ID",keycols$mean, keycols$std)]


## STEP 3:  Uses descriptive activity names to name the activities in the data set.

## Name the activities in the combined data set

activity <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
names(activity) <- c("Activity_ID","Activity_Label")
pretidy2 <- merge(pretidy, activity, by = "Activity_ID")

## STEP 4:  Appropriately labels the data set with descriptive activity names. 

datanames <- names(pretidy2)
safenames <- c("Activity_ID","Subject_ID","Activity_Label")

for( i in 1:length(datanames) ){
  name <- datanames[i]
  if( ! name %in% safenames ) {
    x <- gsub("^t", "Time Domain ", name)
    x <- gsub("^f", "Frequency Domain ", x)
    x <- gsub(".std", "Standard Deviation ", x)
    x <- gsub(".mean", "Mean ", x)
    x <- gsub("-", "", x)
    x <- gsub("Acc", "Linear Acceleration ", x)
    x <- gsub("Jerk", "Jerk ", x)
    x <- gsub("Gyro", "Angular Velocity ", x)
    x <- gsub("Mag","Magnitude ", x)
    x <- gsub("Body", "Body ", x)
    x <- gsub("Gravity", "Gravity ", x)
    names(pretidy2)[names(pretidy2)==name] <- x
  }
}

## STEP 5:  Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

tidymeans <- setdiff(colnames(pretidy2), safenames)
tidymelt <- melt(pretidy2, id = safenames, measure.vars = tidymeans)
tidy <- dcast(tidymelt, Activity_Label + Subject_ID ~ variable, mean)
write.table(tidy, file="tidy.txt", sep = "\t", row.names = TRUE)

