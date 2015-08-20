#Coursera Project
#Getting and Cleaning Data
#-----------------------------------------

#Read in data
getwd() #Current working directory
dir.create("Project") 
fileURL<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"  
download.file(fileURL,destfile="./Project/file.zip")
unzip("./Project/file.zip",exdir="./Project")

#Test data
test_data<-read.table("./Project/UCI HAR Dataset/test/X_test.txt",header=FALSE,sep="")
test_lab<-read.table("./Project/UCI HAR Dataset/test/y_test.txt",header=FALSE,sep="")
test_subj<-read.table("./Project/UCI HAR Dataset/test/subject_test.txt",header=FALSE,sep="")

#Train data
train_data<-read.table("./Project/UCI HAR Dataset/train/X_train.txt",header=FALSE,sep="")
train_lab<-read.table("./Project/UCI HAR Dataset/train/y_train.txt",header=FALSE,sep="")
train_subj<-read.table("./Project/UCI HAR Dataset/train/subject_train.txt",header=FALSE,sep="")

#Feature and Activity labels
features<-read.table("./Project/UCI HAR Dataset/features.txt",header=FALSE,sep="")
act_labels<-read.table("./Project/UCI HAR Dataset/activity_labels.txt",header=FALSE,sep="")

#Relabel variables
feat<-features$V2
colnames(test_data)<-feat
colnames(train_data)<-feat
library(dplyr)
test_lab<-rename(test_lab,label=V1)
test_subj<-rename(test_subj,subject=V1)
test_all<-cbind(test_subj,test_lab,test_data)
train_lab<-rename(train_lab,label=V1)
train_subj<-rename(train_subj,subject=V1)
train_all<-cbind(train_subj,train_lab,train_data)

#Append training and test sets
test_train<-rbind(test_all,train_all)

#Extract the mean and SD for each measurement
tomatch<-c("mean","std","subject","label")
test_train2<-test_train[,grep(paste(tomatch,collapse="|"),names(test_train))]

#Add the activity labels
test_train3<-merge(test_train2,act_labels,by.x="label",by.y="V1")
test_train3<-rename(test_train3,activity=V2)
test_train3<-arrange(test_train3,subject,label)
test_train4<-select(test_train3,subject,activity,everything(),-label)

#Create a 2nd tidy data set with the avg of each variable for each activity and subject
secondset<-group_by(test_train4,subject,activity)
avg_data<-summarise_each(secondset,funs(mean))

write.table(avg_data,file="./Project/Dataset.txt",row.name=FALSE)
