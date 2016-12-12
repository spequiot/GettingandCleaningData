# Getting and Cleaning Data Project

The project consists of merging test and training sets of data coming from an experiment (Human Activity Recognition Using Smartphones Dataset) consisting on measuring some physical activities with a group of 30 volunteers.


The project contains the following files :

1. Readme.md
2. CodeBook.md : explains how to run the scripts that loads and transforms the data
3. makeTidyDataSet.R : script to execute
4. FUCI_HAR_Dataset.zip : source data
5. MergedData.txt : file containing the merged data
  * Contains only the measures from X_test and X_train files that are a mean or a standard deviation (ie. the feature names containing _-mean_ or _-std_ text)
6. SummaryzedData.txt : file containing the summarized data
  * Contains the mean of each MergedData.txt dataset measurements, group by activity and subject

##Run the script

The makeTidyDataSet.R contains only one function "makeTidyData(unzipData=TRUE)"
  
    _unzipdata_ : indicate if we want to unzip the file (by default) or skip this process to save time if we re-run the function.


* The FUCI_HAR_Dataset.zip must be in the R working directory
* The script unzip the file in the same directory, unless you set the optional parameter unzipData=FALSE, that allow to avoid unzip the file again if already done
* Test and training merge steps are:
 * loading all the files
    * features.txt is used to name columns when loading X_test/train files
    * Files in _inertial signal_ folder are not used
 * subject_test/train, X_test/train and Y_test/train datasets columns are binded (using cbind)
 * Y_test/train are merged with activity_label to have the activity names column
 * the 2 resulting datasets (test and train) rows are binded (using rbind)
 * the columns are renamed to be explicit
* Summarized data steps are:
 * melting the merged dataset by activityName and subjectId
 * apply a dcast with mean function
* The script output 2 files using write.table function
  * MergedData.txt
  * SummeryzedData.txt

To read the datasets, use read.table(filename, header=TRUE)
