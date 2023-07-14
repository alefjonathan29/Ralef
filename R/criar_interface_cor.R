
cria_interface_cor <- function(data,grupo) {
  library(shiny)
  library(ggplot2)
  library(GGally)

  ui <- fluidPage(
    titlePanel("Gráfico de Pares do Iris Dataset"),
    sidebarLayout(
      sidebarPanel(
        p("Selecione a cor com base na espécie:"),
        selectInput("cor1", "Cor1:",
                    choices = c("Nenhum", names(data)))
      ),
      mainPanel(
        plotOutput("ggpairs_plot"),
        verbatimTextOutput('codigo_grafico')
      )
    )
  )
  server <- function(input, output) {
    output$ggpairs_plot <- renderPlot({
      grupo <- data[[input$cor1]]
      new_data <- data[, sapply(data, is.numeric)]
      new_data$grupo <- grupo
      gg <- ggpairs(new_data, aes(color = grupo)) + theme_bw()
      print(gg)
    })
    output$codigo_grafico <- renderText({

      grupo <- data[[input$cor1]]
      new_data <- data[, sapply(data, is.numeric)]
      new_data$grupo <- grupo
        code <- paste0("ggpairs(dados, aes(color =",
                       grupo, ") + theme_bw()")

      code
    })
  }

  shinyApp(ui, server)
}

