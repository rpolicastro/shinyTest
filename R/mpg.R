
#' MPG UI
#' @export

mpgUI <- function(id) {
  ns <- NS(id)
  # Sidebar panel for inputs.
  pageWithSidebar(
    # App title.
    headerPanel("Miles Per Gallon"),
    # Sidebar inputs.
    sidebarPanel(
      # Input: Selector for variable to plot against mpg.
      selectInput(
        ns("variable"), "Variable:",
        c("Cylinders" = "cyl", "Transmission" = "am", "Gears" = "gear")
      ),
      # Input: Checkbox for whether outliers should be included.
      checkboxInput(ns("outliers"), "Show outliers", TRUE)
    ),
    # Output title and plot.
    mainPanel(
      # Output: Formatted text for caption.
      h3(textOutput(ns("caption"))),
      # Output: Plot of the requested variable against mpg.
      plotOutput(ns("mpgPlot"))
    )
  )
}

#' MPG Server
#' @export

mpgServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    mpgData <- mtcars
    mpgData$am <- factor(mpgData$am, labels = c("Automatic", "Manual"))
    # Compute the formula text.
    formulaText <- reactive({paste("mpg ~", input$variable)})
    # Return the formula text for printing as a caption.
    output$caption <- renderText({formulaText()})
    # Generate a plot of the requested variable against mpg.
    output$mpgPlot <- renderPlot({
      boxplot(
        as.formula(formulaText()), data = mpgData,
        outline = input$outliers, col = "#75AADB", pch = 19
      )
    })
  })
}
