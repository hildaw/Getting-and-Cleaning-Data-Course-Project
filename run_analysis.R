getwd()
setwd("E:/Data Science/course 3 clean data")

if(!file.exists("./project"))
        {dir.create("./project")}

##download file
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./project/Dataset.zip")

# Unzip dataSet to /project directory
unzip(zipfile="./project/Dataset.zip",exdir="./project")

#look the unziped files,read README,
# project asks for test & training data:

#'train/X_train.txt': Training set.
#'train/y_train.txt': Training labels.
#'test/X_test.txt': Test set.
#'test/y_test.txt': Test labels.
#'
#'#'features.txt': List of all features.
#'#'activity_labels.txt': Links the class labels with their activity name.
#'
#'The following files are available for the train and test data. Their descriptions are equivalent. 
#'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 
#'
# read training data with training label and subject
trainset<-read.table("./project/UCI HAR Dataset/train/X_train.txt")
trainlabel<-read.table("./project/UCI HAR Dataset/train/Y_train.txt")
trainsubjct<-read.table("./project/UCI HAR Dataset/train/subject_train.txt")

# read test data with training label and subject
testset<-read.table("./project/UCI HAR Dataset/test/X_test.txt")
testlabel<-read.table("./project/UCI HAR Dataset/test/Y_test.txt")
testsubjct<-read.table("./project/UCI HAR Dataset/test/subject_test.txt")

# read features get features
feature<-read.table("./project/UCI HAR Dataset/features.txt")

# read activity to class activity
activtlabel<-read.table("./project/UCI HAR Dataset/activity_labels.txt")

# read data first
dim(trainset) #7352*561
head(trainset,1)

dim(trainlabel)#7352*1 #cbind to add column
head(trainlabel)
unique(trainlabel) #1-6 for activities

dim(trainsubjct)#7352*1 #cbind to add column
head(trainsubjct)
unique(trainsubjct)# 1-30 subjects 

dim(testset) #2947*561 (rbind for test and training)
head(testset,1)

dim(testlabel)#2947*1
head(testlabel)

dim(testsubjct)#2947*1 
head(testsubjct)


#non of them has column names

dim(feature)#561*2 variable names for columns
head(feature)

dim(activtlabel)#6*2 6 activity
head(activtlabel)


#assign column names to training & data set 
colnames(trainset)<-feature[,2]
colnames(testset)<-feature[,2]

# relate activitylabel to trainlabel
colnames(activtlabel)<-c("activtid","activtype")#give colname to activity

colnames(trainlabel)<-"activtid" # use same colname of activtlabel 
colnames(testlabel)<-"activtid"

#name colname of subject

colnames(trainsubjct)<-"subjctid"
colnames(testsubjct)<-"subjctid"


# Merge test and training data

# add subject & trainlabel to dataset first
train<-cbind(trainlabel,trainsubjct,trainset)
test<-cbind(testlabel,testsubjct,testset)

# Merge test and training data
Wholedata<-rbind(train,test)

#Task1 done
names(Wholedata) #std,mean,Mean included #features into.txt also indicated

colname<-colnames(Wholedata) 
mean_std<-(grepl("activtid",colname)|grepl("subjctid",colname)|grepl("[Mm][Ee][Aa][Nn]",colname)| grepl("[Ss][Tt][Dd]",colname))
# find mean and standard deviation in measuments


MeannStd<-Wholedata[,mean_std==TRUE] #select mean and standard deviation in measuments
dim(MeannStd) ##check if it works

#Task 2 done

##assign activity type according to activity id
activtdetail<-merge(MeannStd,activtlabel, by="activtid", all=TRUE)
dim(activtdetail)
head(activtdetail)# check if it works


#Task 3 done

names(activtdetail) 

#read features_info.txt
#time domain signals (prefix 't' to denote time)
#'f' to indicate frequency domain signals
#  "Mag" to magnitude
# "ACC" to acceleration
# "Gyro' to gyroscope

library(dplyr)

names(activtdetail)<-gsub(
       "Gyro", "Gyroscope",gsub(
               "Acc","Acceleration",gsub(
                       "Mag","Magnitude",gsub(
                               "^f","frequency",gsub(
                                       "^t", "time",names(activtdetail)
                                       )
                               )
                       )
               ) 
) 
# gsub cannot use C(a,b)
# descriptive label

names(activtdetail) ##check colnames

# Task 4 done

Meanall<-aggregate( .~activtid+subjctid, FUN=mean,activtdetail)
Meanall<- Meanall[Meanall$activtid,Meanall$subjctid] 
## want to use arrange and ddply
#but can't figure out mean for different group
#google for that function
        
dim(Meanall)
str(Meanall)
head(Meanall)## checked 30*6=180 variables

write.table(Meanall, "TidySet.txt", row.name=FALSE)


