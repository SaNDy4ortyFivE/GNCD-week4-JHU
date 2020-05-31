# JHU Getting and Cleaning Data-Week 4

The goal of this project was to create a R script that does the following functions:

1.Merges the training and the test sets to create one data set.  
2.Extracts only the measurements on the mean and standard deviation for each measurement.  
3.Uses descriptive activity names to name the activities in the data set  
4.Appropriately labels the data set with descriptive variable names.  
5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.  

## Dataset
Name: *Human Activity Recognition Using Smartphones Data Set*    
Please refer this [link](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) for downloading and getting additional information on this dataset.

## File Structure
- The R script __runanalysis.R__ is present in the parent folder along with the final tidy dataset named __*tidydataset.txt*__  
- The file __features.txt__ contains names of all the columns and __features_info.txt__ contains additional information regarding each column  
- The folders __'train'__ and __'test'__ each contain 3 additional files inside them denoting the subject number, measurements and activity seperately  
- __activity.txt__ contains mapping of labels to integer value present in activty file named 'y_train'/'y_test' inside the respective folders 
 
## Working R script

1. Reads all the text files present in their respective folders
2. Column binds the test and training dataset seperately using cbind()
3. Row binds the test and training dataset rbind()
4. Reads all column names from the file *features.txt*
5. Assigns these names to combined dataset. Also referred to as 'raw_dataset'  
6. Selects all column names that have 'mean' or 'std' as substring in them using grep()  
7. Subsets the 'raw_dataset' based on names gathered in previous step. Now the dataset is referred as 'req_dataset'  
8. Assigning appropriate column names to 'req_dataset' i.e replaces all '^t' with 'time' and '^f' with 'frequency'.
9. Replaces integer values in 'activity' column with appropriate labels  
10. Selects unique subjects from 'req_dataset'
11. Calculate column means for each activity
12. Appends them to a final dataframe
13. Repeat steps 11,12 for each unique subject
14. Assign appropriate column names to this final dataframe
15. Writes output to file 'tidydataset.txt' 

### Detailed information regarding variables and steps is mentioned in __CodeBook.md__ also.
