#R summary
#Author: Yusuf Tatlier

# Help functions----

? sd
help(sd)
example(sd)


# Location and object check ----

cur_loc=getwd() #Get current working location
setwd(cur_loc)  #Set working location
list.files() #Lists all files in current directory
ls() #Shows saved objects
search() #Shows loaded packages

#Installing packages ----
install.packages("lobstr") #We install a package that we will use
library("lobstr")
require("lobstr")

#Objects in R ----
  #Below we give an idea of how R stores objects
a<-3 #R creates a object with value 3 and binds it to the object with name 'a'
obj_addr(a) #This shows the id of the object
b<-a
obj_addr(b) #Same id
a[2]<-3
obj_addr(a) #Note id has changed, this is called copy-on-modify
obj_addr(b)
  #R uses a garbage collector to remove objects not longer binded to a name object
  #This is done automatically, but can also be called.
gc()

  #Class vs type: Class is the OOP name while type refers to the (most complex) R datatype
  #Of course the class and type can coincide, but doesn't have to be the case
a<-2.0
class(2.0)
typeof(2.0)
  #Class can be changed
class(a)<-"tt"
class(a)

# Printing ----
a=3
print(a)
print("The outcome is:",a) #doesn't work
print("The outcome is:");print(a) #Prints on different lines
cat("The outcome is:",a)

# Sequences ----
  #Non-repetitive sequence
seq(0,3,0.5)
rep(0:3,3)

# Special values ----

  #Infinity
print(Inf>10^8)
print(2^1024)

  #NA, NAN and NULL 
  #NA: Missing value
temp_vec=c(1:3)
length(temp_vec)=4
print(temp_vec)  
  #NaN: Value is non-numeric
print(0/0)
  #NaN and NA are 'contagious' in operations
print(NaN*c(1,2,3))
print(NA*c(1,2,3))
  #NULL: A special null object that is returned when an expression or function results in undefined value
print(NULL)
  #Note how vectors deal with these values, NULL values are not recognized
spec_vec<-c(NULL,NA,NaN,1)
print(spec_vec)

# Attention points ----

  #R starts indexing from 1
temp_vec=c(1,2,3)
for(i in 1:3){print(temp_vec[i])}

  #Coercion: In some cases R can convert the data types, in strongly typed languages this
  #would lead to an error. It has the advantage that it provides flexibility but can also 
  #lead to undesired outcomes. R follows a certain hierarchy in making these conversions.
temp_vec=c(1:5)
class(temp_vec)
temp_vec[3]<-"apple"
class(temp_vec)

  #Comparing different data types can lead to coercion
print("0"==0)
print(identical("0",0)) #Note that '==' gives coercion while identical() does not

# Data types ----

  # scalar datatypes: These are actually one-dimensional vectors
class(2) #class integer exists, but note that by default an integer is of class numeric
class(as.integer(2)) #Note the difference
class(2.0)
typeof(2.0) #Note it is different from class
class("test")
class(as.character(2.0))
a<-3
a[2]<-3
print(a) #Note that a was already open for vector operations

  #Compound data types
test_vector<-c(1:10) #Vectors are homogeneous (coercion can occur with newly added datatypes)

test_matrix<-c(1:12)
dim(test_matrix)<-c(3,4) #Matrices are defined by changing dimensions on a vector

test_array<-c(1:27)
dim(test_array)<-c(3,3,3) #Arrays are extensions of matrices to more than 2 dimensions

test_list<-list(a=1,b=2,c="string_a",d=test_vector) #Lists are heterogeneous

test_factors<-c("Amsterdam","Brussels","Amsterdam","Tokio","Tokio","Berlin","Amsterdam")
test_factors<-factor(test_factors) #Note factors are categorical variables with levels

test_df <- data.frame(a=c(1:3),b=c("Apple","Banana","Cherry")) #Dataframes can be seen as 
  # tables, different columns can contain different datatypes.

# Vectors -----------------------------------------------------------------
  #Vectors are homogeneous, mutable, indexed by position and can have names

vector_1<-c(1:10)
vector_0<-c(10,9)
names(vector_0)<-c("A","B") #Giving names to vectors
vector_0

  #Vectors can also be used as some sort of equivalent of dictionaries in Python
dict_vec<-c("a"="Apple","b"="Banana","c"="Cherry")
print(dict_vec[1])
print(dict_vec["c"])

  #Selecting elements
vector_1[c(4:6)]  #Note that the selection also takes the last element (different from Python)
head(vector_1,1)  #Returns the first element
tail(vector_1,1)  #Returns the last element

  #Finding NA and NaN values
test_vec<-c(NA,1:3,NaN,NULL,NULL,NA)
is.na(test_vec) #Works on all three types

  #Finding indices with which() 
3 %in% test_vec #Checks whether element occurs in vectors
test_ind<-which(is.na(test_vec)) #provides indices for which condition applies
print(test_ind)

  #Replacing values
vector_1[5]=10 #Note that a vector is mutable

  #Adding elements
vector_1[11]=44
vector_1[15]=100 #Intermediate values are set to NA
vector_1<-append(vector_1,20)
vector_1<-c(vector_1,42)
length(vector_1)<-25 #Note that in R objects can be 'shaped' by changing its dimensions

  #Assigning creates distinct copies
vector_2=vector_1
vector_1[16]=99
identical(vector_1,vector_2) #checks whether two objects are identical

  #Removing elements
vector_1 <-vector_1[-length(vector_1)] #remove operation doesn't permanently change the vector  

  #Finding elements
which(vector_1==10)
vector_1[-which(vector_1==10)]
vector_1==2  #Note an individual check is done and a boolean vector is returned 
             #(different from 'direct' check in Python)

#Simple arithmetic
new_vector = c(1:5,NA,NA,NA)
new_vector<-new_vector+1  #Note all values are increased by 1, except fr NA
new_vector<-new_vector+c(1,2) #In addition of vectors of unequal length, R uses recycling

  #Operations work element-wise (regardless of vector-vector or vector-scalar operations)
new_vector = c(1:5)
new_vector/2
new_vector %in% c(3,4,5) #A slightly more generic check
new_vector[new_vector %in% c(3,4,5) | new_vector > mean(new_vector) ] #Returns values for which boolean vector values are TRUE
sqrt(new_vector)

  #Other Operations (Use R built in functions)
sort(vector_1) #Sort
rev(vector_1)  #Reverse

# Matrices ----
test_matrix[1,] #subsetting row
test_marix[,1] #subsetting col
test_matrix[1,]*3 #Multiplication of rows
test_matrix[]*3 #Multiplication of all elements
test_matrix[2,3]=NaN #Change values
is.na(test_matrix) #Find NaN or NA values
test_matrix>2 #Test on values
test_matrix[test_matrix>2] #subsetting
sqrt(test_matrix) #Elementwise operations

# List ----
test_list$c #subsetting option 1
test_list[4] #subsetting option 2

  #See the difference
test_list[4]
test_list[[4]]
class(test_list[4])
class(test_list[[4]])

  #Change object
test_list[1]<-test_matrix #Gives an error
test_list[[1]]<-test_matrix #Works

  #unlist operation
unlist(test_list) #Can be useful for some functions that return lists (like map)

# Dataframes ----

  #Sub-selection of rows and columns
iris[,] #Gives everything
names(iris)
iris$Species #Shows only the column Species
iris[1:5,c("Sepal.Length","Species")]

  #Filtering on conditions: Input for filters is a boolean vector (!)
iris[,]
above_mean_SL<-iris[iris$Sepal.Length>mean(iris$Sepal.Length),]
nrow(above_mean_SL)

  #Creating dataframes, adding and removing data
  #Create
df_main=data.frame(index=c(1:5), 
                   countries=c("USA","Germany","Turkey","China","The Netherlands"))

df_cities <- data.frame(index_2=c(1:8),
                        countries=c("USA","USA","Germany","Turkey","USA","Turkey","China","The Netherlands"),
                        cities=c("New York","Chicago","Berlin","Istanbul","Boston","Ankara","Peking","Amsterdam"))

  #Add a new column
df_new_row<-data.frame(index=c(6),countries=c("Mexico"))
df_main=rbind(df_main,df_new_row)

  #Remove a column: Remove using row index
df_main=df_main[-6,]

  #Merging (joining) dataframes
df_total<-merge(df_main,df_cities,by=c("countries"))

# Control statements ----
  #It is good to look at some features of conditional logic and loops in R

  #If-else loops
a=3

if(a==1){
  print("Value is one")
}else if(a==2){
  print("Value is two")
}else{
  print("Value is note one or two")
}

a=2

if(TRUE){
  print(a) #Note that a variable decalared outside the loop is recognized, similar to Python
  a<-3 #New value is assigned
}

print(a) #Note that the value has changed

  #for loops
fruit_vec<-c('a'="Apple",'b'="Banana",'c'="Cherry")

for(i in 1:length(fruit_vec)){
  print(fruit_vec[i])
}

for(elem in fruit_vec){
  print(elem)
}

  #Equivalent of enumerate in python
for (i in seq_along(fruit_vec)){
  print(paste(i,names(fruit_vec)[i],fruit_vec[i]))
}

  #While loops
a=3
while(a>0){
  print(a)
  a=a-1
}


#Functions ----

a=3

  #Simple function
quad_fun<-function(x){
  
  return(x^2)
}

quad_fun_2<-function(x){
  
  (x^2)
  (a^2) #Without return, the function returns the last expression
        #Note that the function recognizes variables outside the function
}

quad_fun(10)
quad_fun_2(10)

  #Can even be shorter
quad_fun_3<-function(x) (x^2)
quad_fun_3(10)

  #Anonymous functions: Sometimes we don't need to define functions 
  #as we will not re-use them.
sapply(1:5,function(x)(x^2)) #Sapply will be discussed in next section

  #Default arguments
f1<-function(x=10){(x^2)}
print(f1())

  #Variable number of inputs (varargs in other prog. languages)
f2<-function(...){  #... indicates variable number of inputs
  print(..2)  #..N indicates that the N'th input should be used
}

  #Function factories: Can be used to define a family of functions
f3<-function(n){
  function(x){
    (x^n)
  }
}

(f3(3))(3)

  #Note that functions in r apply elementwise on vectors
f1(1:10) #Input and output is both a vector, this type of function is called a functional

# Apply functions ----
  #apply functions are faster than looping over compound datatypes in order to apply functions
  #and should typically be preferred for aggregations. Note that in case of a dataframe it 
  #it is similar to application of aggregation functions in SQL.
  #The most used ones will be discussed below (the lesser used ones will not be discussed).
  #The following two categories roughly exist:
  #  - Applying functions along a certain axis: apply,sapply,lapply.
  #    We would for example like to have the mean of all numerical columns in a dataframe.
  #    Difference lies mainly in the object that is returned.
  #  - Applying functions along a certain axis for specified classifications:tapply,by,aggregate
  #    Note that this corresponds with the 'GROUP BY' clause in SQL.
  #

  #apply: Applies a function along the axis of a matrix, array or a dataframe
test_matrix<-c(1:12)
dim(test_matrix)<-c(4,3)
apply(test_matrix,1,sum)
apply(test_matrix,2,sum)
apply(iris[,1:4],2,mean)

  #sapply: Returns a vector, similar to apply
sapply(iris[,1:4],mean)

  #lapply: Returns a list
lapply(iris[,1:4],mean)

  #rapply
rapply(iris,mean,"numeric")

  #eapply: applies the function to all objects in the provided environment
new_env=new.env()
new_env$vec1<-c(1:10)
new_env$vec2<-c(11:20)
new_env$vec3<-c(21:30)
new_env_eapply<-eapply(new_env,mean)

  #Aggregation per categorical column with tapply, by and aggregate

  #tapply:Applies a function per (aggregation) category on one specified column of a 
  #dataframe and returns an array object.
tapply(iris[,1],iris$Species,mean)  

  #by: Applies a function per aggregation category in specified columns of a dataframe and 
  #returns a by object. Note that it is more generic than tapply.
colMeans(iris[,1:4])
by(iris[,1:4],iris$Species,colMeans)  #Notice that the function mean() gives errors
attach(iris)
by(iris[,1:4],Species,colMeans)

  #aggregation: Applies a function per (aggregation) category in specified columns of a 
  #dataframe and returns a dataframe. Note that it requires a list for the aggregation 
  #categories.
aggregate(iris[,1],by=list(iris$Species),mean)

  #Replication of an operation that returns a matrix or array
replicate(3,rnorm(3))

# Exploring data ----

  #Exploring (for dataframes)
data(iris)
dim(iris)
summary(iris)
head(iris,5)
tail(iris,5)

# Useful approaches and tips ----

  #Use apply functions or which() for data cleaning
test_vec<-c(NA,43,34,32,NA,24)
non_NA_vec<-sapply(test_vec,is.na)
test_vec[!non_NA_vec]
test_vec[which(!is.na(test_vec))]

  #Extending an object (for example a vector) through a loop is slower than simply changing
  #values.