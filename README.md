# Moduel3-week4-tidy-data-project
Module3. Week4 Course Project
Rhandley D. Cajote

The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

#The R script called run_analysis.R does the following:
1. Download the zipped dataset from the http source, extracts the data set into the default directory after download
2. Prepare the datapath and filenames of the relevant files in the dataset
3. Load the activity and feature information first, before the actualy train and test data
4. Choose only the feature names that are relevant, those that are mean and standard deviation of the measurements
5. Load the train data frst: subject information, activity labels and observation data specified by the chosen feature names in 4.
6. Column bind all the training data: suject id, labels, observations
7. Load the test data next: subject information, activity labels and observation data specified by the chose feature names in 4.
8. Column bind all the testing data: subject id, labels, observation
9. Merge the datasets, row binding the train and test data sets
10. Convert the activity labels with descriptive names and change to factor class
11. Create a tidy data set that is the mean of each observaton with each subject id and activity pair
12. Write the dataset to a text fiel, the resulting tidy data set is named "tidy_mean_data.txt"
