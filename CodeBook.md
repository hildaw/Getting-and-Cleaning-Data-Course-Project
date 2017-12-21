#Getting and Cleaning Data Course Project
author: "Hildaw"
date: "2017-12-21"
---

## Project Description

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. 
 The goal is to prepare tidy data that can be used for later analysis. 
 You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit:
 1) a tidy data set as described below, 
 2) a link to a Github repository with your script for performing the analysis,
 3) a code book that describes the variables, the data, and any transformations or work that you  performed to clean up the data called CodeBook.md.
 4)You should also include a README.md in the repo with your scripts.

 
 The sample data is available through :https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

 run_analysis.R does the following.
1)Merges the training and the test sets to create one data set.
2)Extracts only the measurements on the mean and standard deviation for each measurement.
3)Uses descriptive activity names to name the activities in the data set
4)Appropriately labels the data set with descriptive variable names.
5)From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

##Study design and data processing

###Collection of the raw data
*Download data.
getwd()
setwd("E:/Data Science/course 3 clean data")

if(!file.exists("./project"))
        {dir.create("./project")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./project/Dataset.zip")
unzip(zipfile="./project/Dataset.zip",exdir="./project")

* Read data
trainset<-read.table("./project/UCI HAR Dataset/train/X_train.txt")
trainlabel<-read.table("./project/UCI HAR Dataset/train/Y_train.txt")
trainsubjct<-read.table("./project/UCI HAR Dataset/train/subject_train.txt")

testset<-read.table("./project/UCI HAR Dataset/test/X_test.txt")
testlabel<-read.table("./project/UCI HAR Dataset/test/Y_test.txt")
testsubjct<-read.table("./project/UCI HAR Dataset/test/subject_test.txt")

feature<-read.table("./project/UCI HAR Dataset/features.txt")
activtlabel<-read.table("./project/UCI HAR Dataset/activity_labels.txt")

*check data use dim(), head(), str()
		

###Notes on the original (raw) data 
No Colnames. Have idea of how to combine data.

##Creating the tidy datafile

###Add colnames and get relationship of activity and train table 
colnames(trainset)<-feature[,2]
colnames(testset)<-feature[,2]
colnames(activtlabel)<-c("activtid","activtype")
colnames(trainlabel)<-"activtid"
colnames(testlabel)<-"activtid"
colnames(trainsubjct)<-"subjctid"
colnames(testsubjct)<-"subjctid"

###Merge Data based on previous data-reading
train<-cbind(trainlabel,trainsubjct,trainset)
test<-cbind(testlabel,testsubjct,testset)
Wholedata<-rbind(train,test)

### create data only contains mean and standard deviation
colname<-colnames(Wholedata) 
mean_std<-(grepl("activtid",colname)|grepl("subjctid",colname)|grepl("[Mm][Ee][Aa][Nn]",colname)| grepl("[Ss][Tt][Dd]",colname))
MeannStd<-Wholedata[,mean_std==TRUE]

### indicate activity id with activity type in data 
activtdetail<-merge(MeannStd,activtlabel, by="activtid", all=TRUE)

### descriptive measurements
read features_into.txt in data file, change "f","t", "Mag", "Acc","Gyro'to "time", "frequency","Magnitude","Acceleration","Gyroscope"

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

###calculate mean for different group of subject and activity
Meanall<-aggregate( .~activtid+subjctid, FUN=mean,activtdetail)
Meanall<- Meanall[Meanall$activtid,Meanall$subjctid]

### Create this new data set with only mean of selected measurements by activity type and subjects.
write.table(Meanall, "TidySet.txt", row.name=FALSE) 


##Description of the variables in the tiny_data.txt file
General description of the file including:
 - Dimensions of the dataset 180*180
 - data frame group by subject and activity
 - Variables present in the dataset:
 [1] "activtid" 											 "subjctid"                                             
 [3] "timeBodyAcceleration-mean()-X" 						 "timeBodyAcceleration-mean()-Y"                        
 [5] "timeBodyAcceleration-mean()-Z" 						 "timeBodyAcceleration-std()-X"                         
 [7] "timeBodyAcceleration-std()-Y"     					 "timeBodyAcceleration-std()-Z"                         
 [9] "timeGravityAcceleration-mean()-X"  					 "timeGravityAcceleration-mean()-Y"                     
[11] "timeGravityAcceleration-mean()-Z"     				 "timeGravityAcceleration-std()-X"                      
[13] "timeGravityAcceleration-std()-Y"      				 "timeGravityAcceleration-std()-Z"                      
[15] "timeBodyAccelerationJerk-mean()-X"    				 "timeBodyAccelerationJerk-mean()-Y"                    
[17] "timeBodyAccelerationJerk-mean()-Z"    				 "timeBodyAccelerationJerk-std()-X"                     
[19] "timeBodyAccelerationJerk-std()-Y"     				 "timeBodyAccelerationJerk-std()-Z"                     
[21] "timeBodyGyroscope-mean()-X"           				 "timeBodyGyroscope-mean()-Y"                           
[23] "timeBodyGyroscope-mean()-Z"           				 "timeBodyGyroscope-std()-X"                            
[25] "timeBodyGyroscope-std()-Y"            				 "timeBodyGyroscope-std()-Z"                            
[27] "timeBodyGyroscopeJerk-mean()-X"       				 "timeBodyGyroscopeJerk-mean()-Y"                       
[29] "timeBodyGyroscopeJerk-mean()-Z"       				 "timeBodyGyroscopeJerk-std()-X"                        
[31] "timeBodyGyroscopeJerk-std()-Y"        				 "timeBodyGyroscopeJerk-std()-Z"                        
[33] "timeBodyAccelerationMagnitude-mean()" 				 "timeBodyAccelerationMagnitude-std()"                  
[35] "timeGravityAccelerationMagnitude-mean()"				 "timeGravityAccelerationMagnitude-std()"               
[37] "timeBodyAccelerationJerkMagnitude-mean()"              "timeBodyAccelerationJerkMagnitude-std()"              
[39] "timeBodyGyroscopeMagnitude-mean()"                     "timeBodyGyroscopeMagnitude-std()"                     
[41] "timeBodyGyroscopeJerkMagnitude-mean()"                 "timeBodyGyroscopeJerkMagnitude-std()"                 
[43] "frequencyBodyAcceleration-mean()-X"                    "frequencyBodyAcceleration-mean()-Y"                   
[45] "frequencyBodyAcceleration-mean()-Z"                    "frequencyBodyAcceleration-std()-X"                    
[47] "frequencyBodyAcceleration-std()-Y"                     "frequencyBodyAcceleration-std()-Z"                    
[49] "frequencyBodyAcceleration-meanFreq()-X"                "frequencyBodyAcceleration-meanFreq()-Y"               
[51] "frequencyBodyAcceleration-meanFreq()-Z"                "frequencyBodyAccelerationJerk-mean()-X"               
[53] "frequencyBodyAccelerationJerk-mean()-Y"                "frequencyBodyAccelerationJerk-mean()-Z"               
[55] "frequencyBodyAccelerationJerk-std()-X"                 "frequencyBodyAccelerationJerk-std()-Y"                
[57] "frequencyBodyAccelerationJerk-std()-Z"                 "frequencyBodyAccelerationJerk-meanFreq()-X"           
[59] "frequencyBodyAccelerationJerk-meanFreq()-Y"            "frequencyBodyAccelerationJerk-meanFreq()-Z"           
[61] "frequencyBodyGyroscope-mean()-X"                       "frequencyBodyGyroscope-mean()-Y"                      
[63] "frequencyBodyGyroscope-mean()-Z"                       "frequencyBodyGyroscope-std()-X"                       
[65] "frequencyBodyGyroscope-std()-Y"                        "frequencyBodyGyroscope-std()-Z"                       
[67] "frequencyBodyGyroscope-meanFreq()-X"                   "frequencyBodyGyroscope-meanFreq()-Y"                  
[69] "frequencyBodyGyroscope-meanFreq()-Z"                   "frequencyBodyAccelerationMagnitude-mean()"            
[71] "frequencyBodyAccelerationMagnitude-std()"              "frequencyBodyAccelerationMagnitude-meanFreq()"        
[73] "frequencyBodyBodyAccelerationJerkMagnitude-mean()"     "frequencyBodyBodyAccelerationJerkMagnitude-std()"     
[75] "frequencyBodyBodyAccelerationJerkMagnitude-meanFreq()" "frequencyBodyBodyGyroscopeMagnitude-mean()"           
[77] "frequencyBodyBodyGyroscopeMagnitude-std()"             "frequencyBodyBodyGyroscopeMagnitude-meanFreq()"       
[79] "frequencyBodyBodyGyroscopeJerkMagnitude-mean()"        "frequencyBodyBodyGyroscopeJerkMagnitude-std()"        
[81] "frequencyBodyBodyGyroscopeJerkMagnitude-meanFreq()"    "angle(tBodyAccelerationMean,gravity)"                 
[83] "angle(tBodyAccelerationJerkMean),gravityMean)"         "angle(tBodyGyroscopeMean,gravityMean)"                
[85] "angle(tBodyGyroscopeJerkMean,gravityMean)"             "angle(X,gravityMean)"                                 
[87] "angle(Y,gravityMean)"                                  "angle(Z,gravityMean)"                                 
[89] "activtype"   



###Variable 
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.
mean(): Mean value
std(): Standard deviation
Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:
gravityMean
tBodyAccMean
tBodyAccJerkMean
tBodyGyroMean
tBodyGyroJerkMean

Some information on the variable including:
 - Class of the variable : string and numbers
 - Unique values/levels of the variable: 1-6 activity and 30 subjects
 - Unit of measurement (if no unit of measurement list this as well)
 

