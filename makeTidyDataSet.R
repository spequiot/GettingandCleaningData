## This function loads data from "Human Activity Recognition Using Smartphones Dataset version 1.0" label and :
##      1- Merge training and test data set and extract only mean and standard deviation measurementd
##      2- Summarize the data set with the mean of each measure by subject and feature
##      3- Output thje 2 datasets in the files : MergedData.txt and SummaryzedData.txt
##              
##      Notes
##      * The function reads and unzips the source file containing the data into the working directory
##      * The function writes the resulting data set into the working directory
##      * To read the result data sets, use read.table(file_path, header=TRUE) function

makeTidyData<- function(unzipData=TRUE){
        library(plyr)
        library(reshape2)
        
        #Set directories
        rootdir<-"./UCI HAR Dataset"
        testdir<-paste0(rootdir,"/test")
        traindir<-paste0(rootdir,"/train")
        
#-------Load data
        print("Loading data")
        
        #Unzip the file
        if(unzipData){
                if(!file.exists("FUCI_HAR_Dataset.zip")){
                        stop("File UCI_HAR_Dataset.zip does not exists")
                }
                unzip("FUCI_HAR_Dataset.zip")        
        }
        
        #Read labels
        featurelist<-read.csv(paste0(rootdir,"/features.txt"), header = FALSE, sep="",col.names = c("featureId","featureName"))
        activitylist<-read.csv(paste0(rootdir,"/activity_labels.txt"), header = FALSE, sep="",col.names = c("activityId","activityName"))
        
        #Clean feature names (remove the () and replace - by _ so we dont endup with dots in col names)
        featurelist$featureName <- gsub('()',"",featurelist$featureName,fixed=TRUE)
        featurelist$featureName <- gsub('-',"_",featurelist$featureName,fixed=TRUE)
        
        #Read test data files
        subjectTest<-read.csv(paste0(testdir,"/subject_test.txt"),header = FALSE, sep="",col.names = "subjectId")
        XTest<-read.csv(paste0(testdir,"/X_test.txt"),header = FALSE, sep="",col.names = featurelist$featureName)
        YTest<-read.csv(paste0(testdir,"/Y_test.txt"),header = FALSE, sep="",col.names = "activityId")
        
        #Read train data files
        subjectTrain<-read.csv(paste0(traindir,"/subject_train.txt"),header = FALSE, sep="",col.names = "subjectId")
        XTrain<-read.csv(paste0(traindir,"/X_train.txt"),header = FALSE, sep="",col.names = featurelist$featureName)
        YTrain<-read.csv(paste0(traindir,"/Y_train.txt"),header = FALSE, sep="",col.names = "activityId")
        
#-------Build merged data set
        print("Building merged data set")
        
        #append test and train data sets
        subjectData<-rbind(subjectTest,subjectTrain)
        XData<-rbind(XTest,XTrain)
        YData<-rbind(YTest,YTrain)
        
        #Add activity description to YData (merge YData with activitylist)
        YData <- merge(YData,activitylist,all = FALSE)
        
        #Subset to mean and std measurements only
        meanstdCol <- grep('_mean|_std',featurelist$featureName)
        XData<-XData[,meanstdCol]
        
        #append subject, Y and X data
        Data <- cbind(subjectData,YData,XData)
        
#-------Rename measurement columns
        cnames<-colnames(Data)
        cnames <- gsub('^t',"TimeSignal_",cnames)
        cnames <- gsub('^f',"FrequencySignal_",cnames)
        cnames <- gsub('Acc',"Acceleration",cnames)
        cnames <- gsub('Gyro',"AngularVelocity",cnames)
        cnames <- gsub('Mag',"Magnitude",cnames)
        cnames <- gsub('_std',"_standardDeviation",cnames)
        cnames <- gsub('_meanFreq',"_meanFrequency",cnames)
        
        colnames(Data)<-cnames
        
#-------Build summarized Data set
        print ("Building summarized Data set")
        
        #Create summarized data set with average of each variable and each activity and subject
        summaryData <- melt(Data,id=c("activityName","subjectId"),measure.vars=c(4:dim(Data)[2]))
        summaryData <- dcast(summaryData,activityName + subjectId ~ variable,mean)
        
        
#-------Write data into files
        print ("Writing data to files")
        write.table(Data,"MergedData.txt")
        write.table(summaryData,"SummaryzedData.txt")
        
}