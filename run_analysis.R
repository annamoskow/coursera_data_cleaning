##[PART 1: EXTRACT AND MERGE FILES INTO ONE DATASET]##

#create empty directory to load data into
if(!file.exists("./data")){
  dir.create("./data")
}
#download file
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile = "./data/wearables.zip", method = "curl")
unzip(zipfile="./data/wearables.zip", exdir="./data")

#install packages for data tidying
install.packages("data.table")
library(data.table)
install.packages("tidyr")
library(tidyr)
install.packages("dplyr")
library(dplyr)

#read in relevant data sets
activity_labels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
features <- read.table("./data/UCI HAR Dataset/features.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/Y_test.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")

#add relevant column names; xdata taken from features.txt
colnames(activity_labels) <- c("activityID", "activityType")

colnames(x_train) <- features[,2]
colnames(y_train) <- "activityID"
colnames(subject_train) <- "subjectID"

colnames(x_test) <- features[,2]
colnames(y_test) <- "activityID"
colnames(subject_test) <- "subjectID"

#merge training and test data sets
xdata <- rbind(x_train, x_test)
ydata <- rbind(y_train, y_test)
subjectdata <- rbind(subject_train, subject_test)
merged_data <- cbind(subjectdata, ydata, xdata)

##[PART 2: EXTRACT ONLY MEAN AND SD MEASUREMENTS]###

meansd_data <- merged_data %>%
  select(subjectID, activityID, contains("mean"),
         contains("std"))

##[PART 3: USE DESCRIPTIVE ACTIVITY NAMES TO NAME ACTIVITIES IN DATA SET]##

tidy <- meansd_data
tidy$activityID <- activity_labels[tidy$activityID, 2]

##[PART 4: LABEL VARIABLES WITH DESCRIPTIVE NAMES]##

names(tidy)[2] = "activity"
names(tidy) <- gsub("^t", "Time", names(tidy))
names(tidy) <- gsub("Acc", "Accelerometer", names(tidy))
names(tidy) <- gsub("-mean()", "Mean", names(tidy), ignore.case=T)
names(tidy) <- gsub("Gyro", "Gyroscope", names(tidy))
names(tidy) <- gsub("^f", "Frequency", names(tidy), ignore.case=T)
names(tidy) <- gsub("angle", "Angle", names(tidy))
names(tidy) <- gsub("mag", "Magnitude", names(tidy), ignore.case=T)
names(tidy) <- gsub("std", "STD", names(tidy), ignore.case=T)
names(tidy) <- gsub("Freq()", "Frequency", names(tidy), ignore.case=T)
names(tidy) <- gsub("BodyBody", "Body", names(tidy), ignore.case=T)
names(tidy) <- gsub("Frequencyuency", "Frequency", names(tidy))
names(tidy) <- gsub(",gravity", "Gravity", names(tidy))
names(tidy) <- gsub("[\\(\\)]", "", names(tidy))
names(tidy) <- gsub("Anglet", "AngleTime", names(tidy))

##[PART 5: CREATE SECOND DATASET WITH AVERAGE OF EACH VARIABLE]##

#calculate mean of each function
second_tidy <- tidy %>%
  group_by(subjectID, activity) %>%
  summarise_all(funs(mean))

#write into new table
write.table(second_tidy, "second_tidy", row.name=F)


