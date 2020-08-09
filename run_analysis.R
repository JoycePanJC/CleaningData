library(dplyr)
## 0. Assigning all data frames
features<-read.table("./UCI HAR Dataset/features.txt",col.names = c("n","functions"))
activity_labels<-read.table("./UCI HAR Dataset/activity_labels.txt",col.names = c("code","activity"))
X_train<-read.table("./UCI HAR Dataset/train/X_train.txt",col.names = features$functions)
y_train<-read.table("./UCI HAR Dataset/train/y_train.txt",col.names = "code")
subject_train<-read.table("./UCI HAR Dataset/train/subject_train.txt",col.names = "subject")
X_test<-read.table("./UCI HAR Dataset/test/X_test.txt",col.names = features$functions)
y_test<-read.table("./UCI HAR Dataset/test/y_test.txt",col.names = "code")
subject_test<-read.table("./UCI HAR Dataset/test/subject_test.txt",col.names = "subject")

## 1. Merges the training and the test sets to create one data set.
X<-rbind(X_train,X_test)
y<-rbind(y_train,y_test)
subject<-rbind(subject_train,subject_test)
merged_data<-cbind(subject,y,X)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
tidy_data<-select(merged_data,subject,code,contains("mean"),contains("std"))

## 3. Uses descriptive activity names to name the activities in the data set
tidy_data$code<-activity_labels[tidy_data$code,2]

## 4. Appropriately labels the data set with descriptive variable names.
names(tidy_data)[2] = "Activity"
names(tidy_data)<-gsub("^t", "Time", names(tidy_data))
names(tidy_data)<-gsub("^f", "Frequency", names(tidy_data))
names(tidy_data)<-gsub("angle", "Angle", names(tidy_data))
names(tidy_data)<-gsub("Acc", "Accelerometer", names(tidy_data))
names(tidy_data)<-gsub("BodyBody", "Body", names(tidy_data))
names(tidy_data)<-gsub("-freq()", "Frequency", names(tidy_data), ignore.case = TRUE)
names(tidy_data)<-gsub("gravity", "Gravity", names(tidy_data))
names(tidy_data)<-gsub("Gyro", "Gyroscope", names(tidy_data))
names(tidy_data)<-gsub("Mag", "Magnitude", names(tidy_data))
names(tidy_data)<-gsub("-mean()", "Mean", names(tidy_data), ignore.case = TRUE)
names(tidy_data)<-gsub("tBody", "TimeBody", names(tidy_data))
names(tidy_data)<-gsub("-std()", "STD", names(tidy_data), ignore.case = TRUE)


## 5. From the data set in step 4, creates a second, independent tidy data set 
##with the average of each variable for each activity and each subject.
Data_Mean<-sapply(X_select,mean)

## Saving both data set
TDS<- group_by(tidy_data,subject,Activity)
TIDY_DATA_SET<-summarise_all(TDS,funs(mean))
write.table(TIDY_DATA_SET,"Final_Dataset.txt",row.names = FALSE)