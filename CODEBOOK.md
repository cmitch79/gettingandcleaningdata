# Introduction

The script `run_analysis.R`
- downloads the data from
  [UCI Machine Learning Repository](http://archive.ics.uci.edu/ml/index.html)
- merges the training and test sets to create one data set
- extracts only the measurements on the mean and standard deviation
  for each measurement
- uses descriptive activity names to name the activities in the data set (changes activity row values)
- appropriately labels the data set with descriptive activity names (changes column header names)
- creates a second, independent tidy data set with an average of each mean and standard deviation variable
  for each each activity and each subject
  
# 'run_analysis.R'

The script requires gdata and reshape2 as outlined in the code.  Running the script will create the required
working directory and perform the steps outlined in the Introduction above.  The resulting tidy data set called
'tidy.txt' will be saved in the working directory.

# The original data set

The original data set is split into training and test sets (70% and 30%,
respectively) where each partition is also split into three files that contain
- measurements from the accelerometer and gyroscope
- activity label
- identifier of the subject

# Getting and cleaning data

If the data is not already available in the `data` directory, it is downloaded
from UCI repository.

The first step of the preprocessing is to merge the training and test
sets. The test set has 563 variables and 2947 observations.  The training set
has 563 variables and 7352 observations.  When merged, there are 10,299 instances
and 563 columns (561 measurements (features), an activity_id and a subject_id).

After the data sets are merged, columns containing mean and standard deviation features
are extracted for further processing. This leaves a data frame of 81 columns (79 measurements (features),
an activity_id and a subject_id).

Next, the activity_id is replaced with descriptive activity names, defined
in `activity_labels.txt` in the downloaded data folder.  The activities are laying, sitting, standing, walking,
walking_downstairs, walking_upstairs.

Column names are then transformed into a more interpretable format by performing replacment
on text expressions, (e.g. .std becomes Standard Deviation).

In the final step, a tidy data set with the average of each variable for
each activity and each subject is created. The mean and standard deviation features for each subject/activity
combination is taken and the data is then recast putting the mean of each feature into a column.
There are 180 averaged observations for 30 subjects, six activities, 46 mean features and 33 standard deviation features
(81 total columns and (30 members * 6 activities = 180 observations).
The tidy data set is exported to 'tidy.txt' where the first row is the
header containing the names for each column.