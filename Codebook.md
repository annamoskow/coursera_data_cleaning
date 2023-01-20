Codebook

About the source data
- The source data were obtained from the Human Activity Recognition Using Smartphones Data Set. The site where this information was obtained was here: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones. The data for the project are here:  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip. 

About the R script
- The R script performs the following steps of data tidying.

1) Download the dataset

2) Create data tables for each relevant variable (NB: this included all files in the linked dataset, only ignoring the signal files as instructed.) Data tables were labeled as the following:
- activity_labels <- activity_labels.txt
- features <- features.txt
- subject_test <- subject_test.txt
- x_test <- X_test.txt
- y_test <- Y_test.txt
- subject_train <- subject_train.txt
- x_train <- X_train.txt
- y_train <- y_train.txt

3) Merge the data tables into one data set 
- xdata combined x_train and x_test via rbind function
- ydata combined y_train and y_test via rbind function
- subjectdata combined subject_train and subject_test via rbind function
- merged_data combined subjectdata, ydata, and xdata via cbind function

4) Extracts only the measurements on the mean and standard deviation for each measurement.
- A new dataset, meansd_data, was created to select only the subjectID and activityID columns as well as the activities that contained the phrase "mean" or "std".

5) Uses descriptive activity names to name the activities in the data set.
- A new dataset, tidy, replaced the numerical values of activity with the activity phrases by using the second column of the activity_labels table.

6) Appropriately labels the data set with descriptive variable names. 
- Variables renamed to more clearly express their data. Acronyms, misspellings, and other labels that were hard to read were renamed (e.g., "t" was changed to 
"Time").

7) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
- A new dataset, second_tidy, was created by using a group_by function followed by a summarise_all function to show the mean value of each activity for each subject.