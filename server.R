#install.packages(c("Rcpp", "dplyr"))
library(dplyr)

shinyServer(function(input, output, session) {
  #data <- readRDS("healthexp.Rds")
  #data$Region <- as.factor(data$Region)
  values <- 1:length(levels(data$Region))
  names <- levels(data$Region)
  choices <- as.list(setNames(values, names))
  # Provide explicit colors for regions, so they don't get recoded when the
  # different series happen to be ordered differently from year to year.
  # http://andrewgelman.com/2014/09/11/mysterious-shiny-things/
  defaultColors <- c("#3366cc", "#dc3912", "#ff9900", "#109618", "#990099", "#0099c6", "#dd4477")
  #@Lingani
  #The Next level is to generate those colors automatically because the number of regions may evolve
  series <- structure(
    lapply(defaultColors, function(color) { list(color=color) }),
    names = levels(data$Region)
  )
  
  #@Lingani
  #Get the number of countries
  output$nb_countries <- renderText(toString(length(levels(as.factor(data$Country)))))
  
  #@Lingani
  #Filter the disired regions in order to adjust x-axis range
  xlim <- reactive({
    selected_regions <- regions[as.numeric(choices())]
    data<-data[data$Region %in% selected_regions,]
    list(
      min = min(data$Health.Expenditure),
      max = max(data$Health.Expenditure) + 30
    )
  })
  
  #@Lingani
  #Filter the disired regions in order to adjust y-axis range
  ylim <- reactive({
    selected_regions <- regions[as.numeric(choices())]
    data<-data[data$Region %in% selected_regions,]
    list(
      min = min(data$Life.Expectancy),
      max = max(data$Life.Expectancy) + 5
    )
  })

  #@Lingani
  #Dynamically get the selected regions
  choices <- reactive({ 
    input$checkGroup
  })
  
  #@Lingani
  #Output choices to displays just to see if "checkGroupInput" is woking
  output$chs <- reactive({ choices() })

  yearData <- reactive({    
    #@Lingani
    #Filter the disired regions
    selected_regions <- regions[as.numeric(choices())]
    data<-data[data$Region %in% selected_regions,]
    
    # Filter to the desired year, and put the columns
    # in the order that Google's Bubble Chart expects
    # them (name, x, y, color, size). Also sort by region
    # so that Google Charts orders and colors the regions
    # consistently.
    df <- data %>%
      filter(Year == input$year) %>%
      select(Country, Health.Expenditure, Life.Expectancy,
             Region, Population) %>%
      arrange(Region)
  })
  
  output$chart <- reactive({
    # Return the data and options
    #@Lingani
    #Added the two options "hAxis" and "vAxis" to recompute dynamically axis ranges
    list(
      data = googleDataTable(yearData()),
      options = list(
          title = sprintf("Health expenditure vs. life expectancy, %s", input$year),
          series = series,
          hAxis = list(
            title = "Health expenditure, per capita ($USD)",
            viewWindow = xlim()
          ),
          vAxis = list(
            title = "Life expectancy (years)",
            viewWindow = ylim()
          )
      )
    )
  })
  
  # Generate a summary of the data
  output$summary <- renderPrint({
    summary(data)
  })
  
  # Generate an HTML table view of the data
  output$table <- renderTable({
    data.frame(data[1:25, ])
  })
})
