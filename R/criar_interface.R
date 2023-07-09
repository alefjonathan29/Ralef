#' Função para rodar as análises automaticamente
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
#' criar_interface(iris)1
#'
#' @export
criar_interface <- function(dados) {
  # Define a interface gráfica
  ui <- fluidPage(
    titlePanel("Análise de comparação automática (teste t, Mann-Whitney, Anova ou Kruskal-Wallis)"),
    sidebarLayout(
      sidebarPanel(
        selectInput("variavel_dependente", "Variável Dependente:", choices = names(dados)),
        selectInput("grupo", "Categorias (Variável independente):", choices = names(dados))
      ),
      mainPanel(
        plotOutput("boxplot"),
        verbatimTextOutput("resultado")
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
      ggplot(dados_plot, aes(x = grupo, y = variavel_dependente, fill = grupo)) +
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
