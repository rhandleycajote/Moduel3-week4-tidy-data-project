# Module3. Week4 Course Project
# Rhandley D. Cajote

#The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:
# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

#Here are the data for the project:
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

#You should create one R script called run_analysis.R that does the following.
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# load the libraries
library(reshape2)

# Download the dataset if its not yet downloaded
filename <- "getdata_projectfiles_dataset.zip"

## Download and unzip the given dataset:
if (!file.exists(filename)){
     fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
     download.file(fileURL, filename, method="curl")
}  
if (!file.exists("UCI HAR Dataset")) { 
     unzip(filename) 
}

# prepare the data directories and file names if already downloaded
# train data, labels and subjects 
train_fn = file.path("UCI HAR Dataset/train/X_train.txt")
train_label = file.path("UCI HAR Dataset/train/Y_train.txt")
train_subjects = file.path("UCI HAR Dataset/train/subject_train.txt")

# test data, labels and subjects
test_fn = file.path("UCI HAR Dataset/test/X_test.txt")
test_label = file.path("UCI HAR Dataset/test/Y_test.txt")
test_subjects = file.path("UCI HAR Dataset/test/subject_test.txt")

# activity labels
activity_fn = file.path("UCI HAR Dataset/activity_labels.txt")
activityNames = read.table(activity_fn)

# change to lowercase and remove the underscore
colnames(activityNames) <- c("levels", "labels")
activityNames$labels <- sub("_","",tolower(activityNames$labels))

# feature list
feat_fn = file.path("UCI HAR Dataset/features.txt")
featNames = read.table(feat_fn)

# Extract only the featNames with mean and std
featuresMeanStd <- grep(".*mean.*|.*std.*", as.character(featNames$V2))
featuresNames <- featNames$V2[featuresMeanStd]

# remove the excess characters
featuresNames <- gsub('-mean', 'Mean', featuresNames)
featuresNames <- gsub('-std', 'Std', featuresNames)
featuresNames <- gsub('[-()]', '', featuresNames)

# read the train data: subjects, label (activities), data (only output of grep)
# load only the mean and std features
trainSubject <- read.table(train_subjects)
trainLabel <- read.table(train_label)
trainDat <- read.table(train_fn)[featuresMeanStd]

# column bind all the train datasets
trainDat <- cbind(trainSubject, trainLabel, trainDat)

# read the test data: subjects, label (activities), data (only output of grep)
# load only the mean and std features
testSubject <- read.table(test_subjects)
testLabel <- read.table(test_label)
testDat <- read.table(test_fn)[featuresMeanStd]

# column bind all the test datasets
testDat <- cbind(testSubject, testLabel, testDat)

# row bind the train and test data sets
mergedData <- rbind(trainDat, testDat)
# modify the column names
colnames(mergedData) <- c("subject", "activity", featuresNames)

# Replace the activity with descriptive names
mergedData$activity <- factor(mergedData$activity, activityNames$levels, activityNames$labels)

# melt the data with subject and activity as ids
mergedMelt <- melt(mergedData, id = c("subject", "activity"))

# create a tidy data set with subject, activity and mean of observation
mergedMean <- dcast(mergedMelt, subject + activity ~ variable, mean)

# write the data to a text file for submission
write.table(mergedMean, "tidy_mean_data.txt", row.names = FALSE, quote = FALSE)
