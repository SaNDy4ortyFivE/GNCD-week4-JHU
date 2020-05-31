# JHU Getting and Cleaning Data-Week 4
## CodeBook.md

## Variables
|	Variable name		|	Description								|
|:-----------------------------:|:-----------------------------------------------------------------------------:|
|	subs_in_train		|	(dataframe)stores all subjects in training dataset			|
|	x_in_train		|	(dataframe)measurements of all subjects in training dataset		|
|	y_in_train		|	(dataframe)activities of all subjects in training dataset		|
|	train_dataset		|	(dataframe)Combination of subs_in_train,x_in_train and y_in_train	|
|	subs_in_test		|	(dataframe)stores all subjects in test dataset				|
|	x_in_test		|	(dataframe)measurements of all subjects in test dataset			|
|	y_in_test		|	(dataframe)activities of all subjects in test dataset			|
|	test_dataset		|	(dataframe)Combination of subs_in_test,x_in_test and y_in_test		|
|	raw_dataset		|	(dataframe)combination of train_dataset and test_dataset		|
|	all_column_names	|	All column names written in file 'features.txt'				|
|	req_column_names	|	All column names having 'mean' or 'std' in them				|
|	req_dataset		|	Subest of raw_dataset based on column names present in req_column_names	|
|	colnames_to_rename	|	All column names that need to be renamed				|
|	total_columns		|	Total number of columns in req_dataset					|
|	total_subjects		|	Total unique subjects in req_dataset					|
|	all_activites		|	All activities								|
|	df			|	Final dataframe								|
|	tmp1			|	(temporary)stores rows belonging to particular subject			|
|	tmp2			|	(temporary)stores rows belonging to particular activty			|
|	tmp3			|	(temporary)stores column means of columns in tmp2			|


## Steps
1. Reading files
```R
subs_in_train <- read.table("train/subject_train.txt", header = FALSE, sep = "")
x_in_train <- read.table("train/X_train.txt", header = FALSE, sep = "")
y_in_train <- read.table("train/y_train.txt", header = FALSE, sep = "")

subs_in_test <- read.table("test/subject_test.txt", header = FALSE, sep = "")
x_in_test <- read.table("test/X_test.txt", header = FALSE, sep = "")
y_in_test <- read.table("test/y_test.txt", header = FALSE, sep = "")
```
2. Column binding
```R
train_dataset <- cbind(subs_in_train,x_in_train,y_in_train)
test_dataset <- cbind(subs_in_test,x_in_test,y_in_test)
```
3. Row binding the test and training dataset
```R
raw_dataset <- rbind(train_dataset,test_dataset)
```
4.  Reads all column names from the file *features.txt* and processing them
```R
all_column_names <- read.table("features.txt", header = FALSE, sep = "")
##taking only 2nd column. since 1st columns is only index
all_column_names <- subset(all_column_names, select = -c(1))
##Converting factors to charater
all_column_names[] <- lapply(all_column_names,as.character)
##adding new heading as 'subject_no' on top
all_column_names <- rbind("subject_no", all_column_names)
##adding new heading as 'activity' at bottom
all_column_names <- rbind(all_column_names,"activity")
##converting to vector
all_column_names <- as.vector(all_column_names[,1])
```
5. Assigning these names to combined dataset
```R
names(raw_dataset) <- all_column_names
```
6. Selecting all column names that have 'mean' or 'std' in them along with 'subject' and 'activity' columns
```R
req_column_names <- grep("mean|std|activity|subject_no", names(raw_dataset))
req_column_names <- as.vector(req_column_names[])
```
7. Subsetting the "raw_dataset'
```R
req_dataset <- raw_dataset[,req_column_names]
```
8. Assigning appropriate column names to 'req_dataset'
```R
colnames_to_rename <- names(req_dataset)

colnames_to_rename <- gsub("^t", "time", colnames_to_rename)
colnames_to_rename <- gsub("^f", "frequency", colnames_to_rename)
colnames_to_rename <- gsub("BodyBody", "Body", colnames_to_rename)
```
9. Replaces integer values in 'activity' column with appropriate labels
```R
req_dataset[,c("activity")] <- replace(req_dataset[,c("activity")],req_dataset$activity==1,"walking")
req_dataset[,c("activity")] <- replace(req_dataset[,c("activity")],req_dataset$activity==2,"walking upstairs")
req_dataset[,c("activity")] <- replace(req_dataset[,c("activity")],req_dataset$activity==3,"walking downstairs")
req_dataset[,c("activity")] <- replace(req_dataset[,c("activity")],req_dataset$activity==4,"sitting")
req_dataset[,c("activity")] <- replace(req_dataset[,c("activity")],req_dataset$activity==5,"standing")
req_dataset[,c("activity")] <- replace(req_dataset[,c("activity")],req_dataset$activity==6,"laying")
```
10.  Selecting unique subjects from 'req_dataset'
```R
total_subjects <- nrow(distinct(req_dataset,req_dataset$subject_no))
```
11. Calculate column means for each activity  
12.  Append to df
```R
for (act in all_activities){
                tmp2 <- filter(tmp1, activity==act)
                means_of_col <- colMeans(tmp2[,2:(total_columns-1)])
                means_of_col <- (t(means_of_col))
                tmp3 <- means_of_col
                tmp3 <- cbind(s,tmp3,act)
                df <- rbind(df,tmp3)
        }
```
13. Repeat steps 11,12 for each unique subject
```R
for (s in c(1:total_subjects)){
				##steps 11 and 12 here
}
```
14.  Assigning appropriate column names to the final dataframe
```R
names(df) <- names(req_dataset)
```
15. Writes output to file 'tidydataset.txt'
```R
write.table(req_dataset,"tidydataset.txt", row.names = FALSE)
```
