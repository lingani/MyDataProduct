# More info:
#   https://github.com/jcheng5/googleCharts
# Install:
#   devtools::install_github("jcheng5/googleCharts")
library(googleCharts)

data <- readRDS("healthexp.Rds")
data$Region <- as.factor(data$Region)

# Use global max/min for axes so the view window stays
# constant as the user moves between years
xlim <- list(
  min = min(data$Health.Expenditure),
  max = max(data$Health.Expenditure)
)
ylim <- list(
  min = min(data$Life.Expectancy),
  max = max(data$Life.Expectancy)
)


shinyUI(fluidPage(
  
    titlePanel("Data Product Project"),
    withTags({
      div(class="header", checked=NA,
          p("This project is about visualizing how ",
              b("'Life Expectancy' "), "changes over ", b("'Time'"), " with ", b("'Health Expenditure'."),            
              "245", b("countries grouped in 7 regions "), "are invloved. ",
              " To play the chart, check the Regions you want to see in the left panel and hit the play botton ",
              "located below the chart. You can still select or deselect regions while the chart is playing; ", 
              "Axis range and layout will reshaffre reactivelly to render a great visualization.",
              "You can also check the data and summary tabs. Please dont forget to get to the",
              b("About"), "tab for more details on how to run the App and Credit."
          )
      )           
    }),
    
    sidebarLayout(
        sidebarPanel(
          checkboxGroupInput("checkGroup", label = h3("Select Regions"), 
                             choices = choices,
                             #@Lingani
                             #By default select all the regions
                             selected = 1:length(regions)
          )
        ),
        
        mainPanel(
          tabsetPanel(type = "tabs", 
              tabPanel("Plot", 
                  #data <- tableOutput("data"),
                  # This line loads the Google Charts JS library
                  googleChartsInit(),
                  
                  # Use the Google webfont "Source Sans Pro"
                  tags$link(
                    href=paste0("http://fonts.googleapis.com/css?",
                                "family=Source+Sans+Pro:300,600,300italic"),
                    rel="stylesheet", type="text/css"),
                  tags$style(type="text/css",
                             "body {font-family: 'Source Sans Pro'}"
                  ),
                    googleBubbleChart("chart",
                                      width="100%", height = "475px",
                                      # Set the default options for this chart; they can be
                                      # overridden in server.R on a per-update basis. See
                                      # https://developers.google.com/chart/interactive/docs/gallery/bubblechart
                                      # for option documentation.
                                      options = list(
                                        fontName = "Source Sans Pro",
                                        fontSize = 13,
                                        # Set axis labels and ranges
                                        hAxis = list(
                                          title = "Health expenditure, per capita ($USD)",
                                          viewWindow = xlim
                                        ),
                                        vAxis = list(
                                          title = "Life expectancy (years)",
                                          viewWindow = ylim
                                        ),
                                        # The default padding is a little too spaced out
                                        chartArea = list(
                                          top = 50, left = 75,
                                          height = "75%", width = "75%"
                                        ),
                                        # Allow pan/zoom
                                        explorer = list(),
                                        # Set bubble visual props
                                        bubble = list(
                                          opacity = 0.4, stroke = "none",
                                          # Hide bubble label
                                          textStyle = list(
                                            color = "none"
                                          )
                                        ),
                                        # Set fonts
                                        titleTextStyle = list(
                                          fontSize = 16
                                        ),
                                        tooltip = list(
                                          textStyle = list(
                                            fontSize = 12
                                          )
                                        )
                                      )
                    ),
                    fluidRow(
                      
                      shiny::column(4, offset = 4,
                            sliderInput("year", "Year",
                                        min = min(data$Year), max = max(data$Year),
                                        value = min(data$Year), animate = TRUE)
                      )
                    )
            ),            
            
            tabPanel("Summary",
               withTags({
                 div(class="header", checked=NA,
                     p("Below find a summary of the data used for the ploting."),
                     verbatimTextOutput("summary"),
                     p("Go to Next Tab to see an overview of the data.")
                 )                      
               })
            ), 
            tabPanel("Data",                  
               withTags({
                 div(class="header", checked=NA,
                     p("Here I just displayed the first 25 rows of the data"),
                     tableOutput("table"),
                     p("To get the entire data follow the URL: ", 
                      a(href = "https://github.com/jcheng5/googleCharts/blob/master/inst/examples/bubble/healthexp.Rds", "Click Here!", target="_blank")
                     )
                  )           
              })
            ),
            tabPanel("About",
                     withTags({
                       div(class="header", checked=NA,
                           
                           h3("Introduction"),
                           
                           hr(),
                           
                           h5("Origin"),
                           
                           p("The project is inspired by: ", 
                             a(href = "http://shiny.rstudio.com/gallery/google-charts.html", "Google Charts demo.", target="_blank"),
                             "The initial project is host on", a(href = "https://github.com/jcheng5/googleCharts", "github", target="_blank"),
                             "under", a(href = "http://cran.r-project.org/web/licenses/GPL-3", 
                             "GNU General Public License, version 3." , target="_blank"), "Thanks to the contributer",  
                             b(a(href = "https://github.com/jcheng5", "Joe Cheng." , target="_blank"))
                           ),
                           
                           p(b(a(href = "https://github.com/jcheng5", "Joe Cheng.", target="_blank")), 
                             "'s Project purpose was to provide", b("Google Charts bindings for Shiny"),
                             ". The following were the reasons anounced to support the project:"
                           ),
                           
                           p("Although Google Charts bindings for Shiny already exist in the",
                             a(href = "http://cran.r-project.org/web/packages/googleVis/index.html", "googleVis package,"),
                             "these bindings are higher performance and more reliable for Shiny usage. However,",
                             "unlike the googleVis package, this package cannot generate static HTML pages",
                             "it is only for use with live Shiny applications."
                           ),
                           
                           p("Since the last commit dates back 9 months ago, I don't know if this project still get great value today.",
                             "Something is sure, it still is a", b("refference shiny example"), "on",
                             b(a(href = "http://shiny.rstudio.com/gallery/google-charts.html", 
                                 "http://shiny.rstudio.com.", target="_blank"))
                           ),
                           
                           h5("My Contribution"),
                                                      
                           p("While looking for a topic to build my Data Product I came accross that interesting example.",
                             "First, I was willing to see how Sabsaharian Africa is doing about Life expectancy and",
                             "Health Expanditure. I was not even able to see these counties move left nor up.", 
                             "So I decided to allow region selection and then reshope dynamically the chart dimensions.",
                             "Now we can see Burkina Faso my mother country moves a little. This also allow as to better",
                             "make some comparision between regions"
                           ),
                           
                           p("Fell free to play around it and have fan!"),
                           
                           h3("Installation"),
                           
                           hr(),
                           
                           p("Enter these commands into your R console or RStudio console:"),
                           pre(
                             "if (!require(devtools))", 
                             "install.packages(\"devtools\")",
                             "devtools::install_github(\"jcheng5/googleCharts\")",
                             "install.packages(dplyr)"                             
                           ),
                           
                           p("Download ui.R, server.R, global.R and healthexp.Rds. Put all these file in one directory",
                             "swhitch to that directory as working directory and run the shiny app."
                           ),
                           
                           p(b("IMPORTANT !!!: ", "connect to internet when you run the app.")),

                                                      
                           h3("Disclaimer"),
                           
                           hr(),
                           
                           p("This code is brand new. The API may evolve, and even the", 
                             "package name may change. And docs are very sparse at the moment."
                           ),
                           
                           h3("License"),
                           
                           hr(),
                           
                           p(b(a(href = "http://cran.r-project.org/web/licenses/GPL-3", "GNU General Public License, version 3", target="_blank"))), 
                           
                           p("Copyright 2014 malick.lingani@gmail.com")
                           
                           
                       )                      
                     })
            )
          )
        )
      )
    )
)
