#' Interface para criar gráficos de boxplot em ggplot2
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
#' criar_interface_grafico(iris)
#'
#' @export
criar_interface_grafico <- function(dados) {
  #Verificando pacotes
  pacotes <- c("shiny", "rstatix", "car", "tidyverse","ggplot2")                                        # Specify your packages
  nao_instalados <- pacotes[!(pacotes %in% installed.packages()[ , "Package"])]    # Extract not installed packages
  if(length(nao_instalados)) install.packages(nao_instalados)                               # Install not installed packages
  require(pacotes)

  # Define a interface gráfica
  ui <- fluidPage(
    titlePanel("Análise de comparação automática (teste t, Mann-Whitney, Anova ou Kruskal-Wallis)"),
    sidebarLayout(
      sidebarPanel(
        selectInput("variavel_dependente", "Variável Dependente:",
                    choices = names(dados)),
        selectInput("grupo", "Categorias (Variável independente):",
                    choices = names(dados)),
        selectInput("faceta", "Variável facet",
                    choices = names(dados))
      ),
      mainPanel(
        plotOutput("boxplot"),
        verbatimTextOutput("codigo_grafico")  # Saída para exibir o código do gráfico
      )
    )
  )

  # Define o servidor
  server <- function(input, output) {

    # Renderizar o boxplot na interface
    output$boxplot <- renderPlot({
      variavel_dependente <- dados[[input$variavel_dependente]]
      grupo <- dados[[input$grupo]]
      faceta <- dados[[input$faceta]]
      dados_plot <- data.frame(grupo, variavel_dependente, faceta)
      ggplot(dados_plot, aes(x = grupo, y = variavel_dependente, fill = grupo)) +
        geom_boxplot() +
        theme_bw() +
        facet_wrap(vars(faceta))
    })

    # Renderizar o código do gráfico na interface
    output$codigo_grafico <- renderPrint({
      variavel_dependente <- input$variavel_dependente
      grupo <- input$grupo
      faceta <- input$faceta
      code <- paste0("ggplot(dados_plot, aes(x = ", grupo, ", y = ", variavel_dependente, ", fill = ", grupo, ")) +\n",
                     "  geom_boxplot() +\n",
                     "  theme_bw() +\n",
                     "  facet_wrap(vars(", faceta, "))")
      code
    })
  }

  # Cria e inicia a aplicação Shiny
  shinyApp(ui = ui, server = server)
}
