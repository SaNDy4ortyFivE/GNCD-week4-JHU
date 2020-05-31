library(dplyr)

##grabbing train dataset
subs_in_train <- read.table("train/subject_train.txt", header = FALSE, sep = "")
x_in_train <- read.table("train/X_train.txt", header = FALSE, sep = "")
y_in_train <- read.table("train/y_train.txt", header = FALSE, sep = "")

##merging traning dataset by columns
train_dataset <- cbind(subs_in_train,x_in_train,y_in_train)

##grabbing test dataset 
subs_in_test <- read.table("test/subject_test.txt", header = FALSE, sep = "")
x_in_test <- read.table("test/X_test.txt", header = FALSE, sep = "")
y_in_test <- read.table("test/y_test.txt", header = FALSE, sep = "")

##merging test dataset by columns
test_dataset <- cbind(subs_in_test,x_in_test,y_in_test)

##merging train and test dataset by rows 
raw_dataset <- rbind(train_dataset,test_dataset)

##grabbing column names
all_column_names <- read.table("features.txt", header = FALSE, sep = "")

##removing 1st column for all_column_names since its just val1,val2,..
all_column_names <- subset(all_column_names, select = -c(1))

##converting all factors to character
all_column_names[] <- lapply(all_column_names,as.character)

##adding new heading as 'subject_no' on top
all_column_names <- rbind("subject_no", all_column_names)

##adding new heading as 'activity' at bottom
all_column_names <- rbind(all_column_names,"activity")

##converting to vector
all_column_names <- as.vector(all_column_names[,1])

##adding these column names to dataset
names(raw_dataset) <- all_column_names

##grabbing only required column names
req_column_names <- grep("mean|std|activity|subject_no", names(raw_dataset))
req_column_names <- as.vector(req_column_names[])

##grabbing only required columns based on column name present in req_column_names
req_dataset <- raw_dataset[,req_column_names]

##reanming column names of req_dataset
colnames_to_rename <- names(req_dataset)

colnames_to_rename <- gsub("^t", "time", colnames_to_rename)
colnames_to_rename <- gsub("^f", "frequency", colnames_to_rename)
colnames_to_rename <- gsub("BodyBody", "Body", colnames_to_rename)

##reassigning names
names(req_dataset) <- colnames_to_rename

##total columns
total_columns <- ncol(req_dataset)

req_dataset[,c("activity")] <- replace(req_dataset[,c("activity")],req_dataset$activity==1,"walking")
req_dataset[,c("activity")] <- replace(req_dataset[,c("activity")],req_dataset$activity==2,"walking upstairs")
req_dataset[,c("activity")] <- replace(req_dataset[,c("activity")],req_dataset$activity==3,"walking downstairs")
req_dataset[,c("activity")] <- replace(req_dataset[,c("activity")],req_dataset$activity==4,"sitting")
req_dataset[,c("activity")] <- replace(req_dataset[,c("activity")],req_dataset$activity==5,"standing")
req_dataset[,c("activity")] <- replace(req_dataset[,c("activity")],req_dataset$activity==6,"laying")

##grabbing total subjects using unique
total_subjects <- nrow(distinct(req_dataset,req_dataset$subject_no))

##all activity vector
all_activities <- c("walking", "walking upstairs", "walking downstairs", "standing", "sitting", "laying")

##final dataframe
df <- data.frame(matrix(nrow = 0,ncol = total_columns))

for (s in c(1:total_subjects)){
        tmp1 <- filter(req_dataset,req_dataset$subject_no==s)
        for (act in all_activities){
                tmp2 <- filter(tmp1, activity==act)
                means_of_col <- colMeans(tmp2[,2:(total_columns-1)])
                means_of_col <- (t(means_of_col))
                tmp3 <- means_of_col
                tmp3 <- cbind(s,tmp3,act)
                df <- rbind(df,tmp3)
        }
}

names(df) <- names(req_dataset)

write.table(req_dataset,"tidydataset.txt",row.names = FALSE)





