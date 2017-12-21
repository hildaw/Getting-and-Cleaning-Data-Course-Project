#Project name: Getting and Cleaning Data Course Project

##Description:
This repository was built for the course project of the "Getting and Cleaning Data" course at Coursera. 
The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis.
You will be required to submit: 
1) a tidy data set as described below,
2) a link to a Github repository with your script for performing the analysis,
3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md.
You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

###The run_analysis.R script should be run on the data and it will complete the following steps to transform the data into something that we are able to glean information out of.
1)Merges the training and the test sets to create one data set.
2)Extracts only the measurements on the mean and standard deviation for each measurement. 
3)Uses descriptive activity names to name the activities in the data set
4)Appropriately labels the data set with descriptive variable names. 
5)From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The Sample data can be obtained from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip.


##Table of Contents: 
1)run_analysis.R - This script explains analysis and steps of building up the tidy data according to the requirements.
2)TidySet.txt - A tidy and clean version dragged from the sample data following all requirements.
3)CodeBook.md - Contains the definitions of each of the columns in our generated tidy.txt file.
4)README.md - General introduction of the project.

##Installation: Installation R i386 3.4.3, Rstudio 1.1.1 383 on Windows 7, 32bit. 


##Usage: When you use run_analysis.R script, please change directory to your local files(use setwd()).

