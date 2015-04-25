#load datasets into R
subject_test<-read.table("./UCI HAR Dataset/test/subject_test.txt")
x_test<-read.table("./UCI HAR Dataset/test/X_test.txt")
y_test<-read.table("./UCI HAR Dataset/test/y_test.txt")
subject_train<-read.table("./UCI HAR Dataset/train/subject_train.txt")
x_train<-read.table("./UCI HAR Dataset/train/X_train.txt")
y_train<-read.table("./UCI HAR Dataset/train/y_train.txt")
features<-read.table("./UCI HAR Dataset/features.txt")

#merge datasets by rows
merge_x=rbind(x_test,x_train)
merge_y=rbind(y_test,y_train)
merge_subject=rbind(subject_test,subject_train)

#rename variables
names(merge_x)<-features$V2
names(merge_y)<-c("activity")
names(merge_subject)<-c("subject")

#merge datasets by coloum
mergeData=cbind(merge_subject,merge_y,merge_x)

#subset data 
sub_features<-features$V2[grep("mean\\(\\)|std\\(\\)", features$V2)]
mean_std<-c(as.character(sub_features),"subject","activity")
mergeData<-subset(mergeData,select=mean_std)

#name activity
mergeData$activity<-gsub("1","Walking",mergeData$activity)
mergeData$activity<-gsub("2","Walking_upstairs",mergeData$activity)
mergeData$activity<-gsub("3","Walking_downstairs",mergeData$activity)
mergeData$activity<-gsub("4","Sitting",mergeData$activity)
mergeData$activity<-gsub("5","Standing",mergeData$activity)
mergeData$activity<-gsub("6","Laying",mergeData$activity)

#rename variables with descriptive names
names(mergeData)<-gsub("^t","time",names(mergeData))
names(mergeData)<-gsub("^f", "frequency", names(mergeData))
names(mergeData)<-gsub("Acc", "Accelerometer", names(mergeData))
names(mergeData)<-gsub("Gyro", "Gyroscope", names(mergeData))
names(mergeData)<-gsub("Mag", "Magnitude", names(mergeData))
names(mergeData)<-gsub("BodyBody", "Body", names(mergeData))

#subset data by activity and subject
library(plyr)
data2<-aggregate(.~subject+activity,mergeData,mean)
data2<-data2[order(data2$subject,data2$activity),]

#upload the data to a txt file
write.table(data2,file="tidydata.txt",row.name=FALSE)



