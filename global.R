data <- readRDS("healthexp.Rds")
data$Region <- as.factor(data$Region)
#@Lingani
#Getting region's  names for subsetting by region purposes
#The initial choices are all the regions. 
#We alse get nb of countries fort simple display

regions <- levels(data$Region)

values <- 1:length(levels(data$Region))
names <- levels(data$Region)
choices <- as.list(setNames(values, names))

nb_countries <- length(levels(as.factor(data$Country)));


