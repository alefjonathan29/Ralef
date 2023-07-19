#' Interface para comparação automática de amostras
#'
#' Esse função executa uma interface gráfica que vc pode selecionar as variáveis
#' que devem ser comparadas. Ao selecionar as variáveis a interface mostra um
#' boxplot e o resultados do teste de comparação que pode ser teste t,
#' Mann-Whitney, Anova ou Kruskal-Wallis. A análise é selecionada automaticamente
#' a partir do atendimento dos pressupostos.
#'
#' @param a É um dataframe, que é o mesmo que seu conjunto de dados.
#'
#' @examples
#' criar_interface(iris)
#'
#' @export
criar_interface <- function(dados) {
  #Verificando pacotes
  pacotes <- c("shiny", "rstatix", "car", "tidyverse","ggplot2")                                        # Specify your packages
  nao_instalados <- pacotes[!(pacotes %in% installed.packages()[ , "Package"])]    # Extract not installed packages
  if(length(nao_instalados)) install.packages(nao_instalados)                               # Install not installed packages
  lapply(pacotes, require, character.only = TRUE)

  # Define a interface gráfica
  ui <- fluidPage(
    titlePanel("Análise de comparação automática (teste t, Mann-Whitney, Anova ou Kruskal-Wallis)"),
    sidebarLayout(
      sidebarPanel(
        selectInput("variavel_dependente", "Variável Dependente:", choices = names(dados)),
        selectInput("grupo", "Categorias (Variável independente):", choices = names(dados)),


        ),
      mainPanel(
        tabsetPanel(
          tabPanel("Plot",plotOutput("boxplot")),
          tabPanel("Sumário",verbatimTextOutput("resultado"))
        )
      )
    )
  )

  # Define o servidor
  server <- function(input, output) {

    # Função para executar o teste de pressupostos
    executar_teste <- function() {
      variavel_dependente <- dados[[input$variavel_dependente]]
      grupo <- dados[[input$grupo]]
      resultado <- testar_Ralef(variavel_dependente, grupo)
      return(resultado)
    }

    # Renderizar o boxplot na interface
    output$boxplot <- renderPlot({
      variavel_dependente <- dados[[input$variavel_dependente]]
      grupo <- dados[[input$grupo]]
      dados_plot <- data.frame(grupo, variavel_dependente)
      ggplot(dados_plot, aes(x = as.factor(grupo), y = variavel_dependente, fill = grupo)) +
        geom_boxplot()+
        theme_bw()
    })

    # Renderizar o resultado na interface
    output$resultado <- renderPrint({
      executar_teste()
    })
  }

  # Cria e inicia a aplicação Shiny
  shinyApp(ui = ui, server = server)
}
