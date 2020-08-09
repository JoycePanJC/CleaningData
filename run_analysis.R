## 1. Merges the training and the test sets to create one data set.
X_train<-read.table("./UCI HAR Dataset/train/X_train.txt")
y_train<-read.table("./UCI HAR Dataset/train/y_train.txt")
X_test<-read.table("./UCI HAR Dataset/test/X_test.txt")
y_test<-read.table("./UCI HAR Dataset/test/y_test.txt")
X<-rbind(X_train,X_test)
y<-rbind(y_train,y_test)
features<-read.table("./UCI HAR Dataset/features.txt")
activity_labels<-read.table("./UCI HAR Dataset/activity_labels.txt")

## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
indices<-grep("^(?=.*(mean\\(\\)|std\\(\\))).*$", features[,2],perl=T)
X_select<-X[,indices]

## 3. Uses descriptive activity names to name the activities in the data set
for(var in 1:nrow(y)){
  y[var,1]<-activity_labels[as.numeric(y[var,1]),2]
}

## 4. Appropriately labels the data set with descriptive variable names.
for(var in names(X_select)){
  names(X_select)[names(X_select)==var]<-paste(y[as.numeric(strsplit(var,split="V")[[1]][2]),1],features[as.numeric(strsplit(var,split="V")[[1]][2]),2])
}

## 5. From the data set in step 4, creates a second, independent tidy data set 
##with the average of each variable for each activity and each subject.
Data_Mean<-sapply(X_select,mean)

## Saving both data set
write.table(X_select,file="./Final_Dataset.txt",col.names = TRUE)
write.table(Data_Mean,file="./Data_Mean.txt",col.names = FALSE)