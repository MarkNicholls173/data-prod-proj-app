#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Fast Car App"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            sliderInput("wt",
                        "Car weight (Thousands of lb)",
                        min = 1,
                        max = 6,
                        value = 2.5,
                        step = 0.5),
            sliderInput("hp",
                        "Car Horsepower",
                        min = 50,
                        max = 400,
                        value = 120),
            sliderInput("disp",
                        "Engine Size (cubic inches)",
                        min = 70,
                        max = 400,
                        value = 150),
            selectInput("cyl",
                        "Number of Cylinders",
                        choices = c(4, 6, 8),
                        selected = 4)
        ),

        # Show a plot of the generated distribution
        mainPanel(
            h2("Predict Quarter Mile Time"),
            p("This app will allow to you predict how fast a car is over a
              standing quarter mile. It uses 4 characteristics of a car: Weight, 
              Horsepower, Engine size and the Number of cylinders as parameters 
              for a machine learning linear regression model trained on the MT 
              cars data set"),
            p("Change values in the sidebar to predict the quarter mile time"),
            wellPanel(htmlOutput("result"))
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    data(mtcars)
    model <- lm(qsec ~ wt + disp + cyl + hp, data = mtcars)
    
    output$result <- renderUI({
        new_data = data.frame(wt = input$wt,
                              hp = input$hp,
                              disp = input$disp,
                              cyl = as.numeric(input$cyl))
        result <- predict(model, new_data)
        h2(paste0("Predicted Time: ", format(result, digits = 2), " seconds"))
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
