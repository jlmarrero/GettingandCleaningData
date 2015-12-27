## Getting and Cleaning Data
## by Jeff Leek, PhD, Roger D. Peng, PhD, Brian Caffo, PhD

## Course Project
## Jonathan L. Marrero

## Import required libraries 
library(dplyr)

## Importing raw data before merging
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

## STEP 1.
## Bind the training and the test sets to create one data set. 

x_new <- rbind(x_train, x_test)
y_new <- rbind(y_train, y_test)
subject_new <- rbind(subject_train, subject_test)
names(y_new) <- "Activity"
names(subject_new) <- "Subjects"

## STEP 2. 
## Extract only the measurements on the mean and standard deviation for each measurement. 
feat <- read.table("UCI HAR Dataset/features.txt")
names(x_new) <- feat$V2
clean <- x_new[, !duplicated(colnames(x_new))]
xstd <- select(clean, contains("std"))
xmean <- select(clean, contains("mean"))
xnew.1 <- cbind(xstd, xmean)

## Step 3.
## Use descriptive activity names to name the activities in the data set.

y_new$Activity <- replace(y_new$Activity, y_new$Activity==1, "WALKING")
y_new$Activity <- replace(y_new$Activity, y_new$Activity==2, "WALKING_UPSTAIRS")
y_new$Activity <- replace(y_new$Activity, y_new$Activity==3, "WALKING_DOWNSTAIRS")
y_new$Activity <- replace(y_new$Activity, y_new$Activity==4, "SITTING")
y_new$Activity <- replace(y_new$Activity, y_new$Activity==5, "STANDING")
y_new$Activity <- replace(y_new$Activity, y_new$Activity==6, "LAYING")

## Step 4. 
## Appropriately label the data set with descriptive variable names. 

names(xnew.1) <- gsub("std()", "StandardDeviation", names(xnew.1))
names(xnew.1) <- gsub("mean", "Mean", names(xnew.1))

## Step 5. 
## Create a second, independent tidy data set with the average of each variable for each activity and each subject. 

allData <- cbind(subject_new, y_new, xnew.1)
tidyData <- allData %>% group_by(Subjects, Activity) %>% summarise_each(funs(mean))
write.table(tidyData, "tidydata.txt", row.name=FALSE)
