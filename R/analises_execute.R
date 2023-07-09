#' Função para rodar as análises automaticamente
#'
#' Esta função executa um algorítimo que avalia os dados e roda a análise
#' que melhor se adequa parar eles. Entre as análises estão o teste t,
#' Mann-Whitney, Anova e Kruskal-Wallis.
#'
#' @param a É a coluna de dados numéricos.
#' @param b É a coluna de dados categóricos.
#'
#' @examples
#' testar_Ralef(iris$, locais)
#'
#' @export
testar_Ralef1 <- function(dados, grupo) {
  # Verificar se são comparados apenas dois grupos
  if (length(unique(grupo)) == 2) {
    # Dados para o primeiro grupo
    dados_grupo1 <- dados[grupo == unique(grupo)[1]]
    # Dados para o segundo grupo
    dados_grupo2 <- dados[grupo == unique(grupo)[2]]

    # Teste de normalidade (Shapiro-Wilk)
    teste_normalidade_grupo1 <- shapiro.test(dados_grupo1)
    teste_normalidade_grupo2 <- shapiro.test(dados_grupo2)

    print(">>>>>>>>>>>Teste de Normalidade - Grupo 1:")
    print(teste_normalidade_grupo1)
    print(">>>>>>>>>>>Teste de Normalidade - Grupo 2:")
    print(teste_normalidade_grupo2)

    # Verificar se os pressupostos são atendidos para ambos os grupos
    if (teste_normalidade_grupo1$p.value > 0.05 & teste_normalidade_grupo2$p.value > 0.05) {
      # Pressupostos atendidos, executar o teste t
      t_test_resultado <- t.test(dados_grupo1, dados_grupo2)
      print(">>>>>>>>>>>Teste t:")
      print(t_test_resultado)
    } else {
      # Pressupostos não atendidos, executar o teste de Mann-Whitney
      mann_whitney_resultado <- wilcox.test(dados_grupo1, dados_grupo2)
      print(">>>>>>>>>>>Teste de Mann-Whitney:")
      mann_whitney_resultado
    }
  } else {
    # Teste de normalidade (Shapiro-Wilk)
    teste_normalidade <- shapiro.test(dados)
    print(">>>>>>>>>>>Teste de Normalidade:")
    print(teste_normalidade)

    # Teste de homogeneidade de variância (Bartlett ou Levene)
    teste_homogeneidade_variancia <- bartlett.test(dados, grupo)
    # Ou use: teste_homogeneidade_variancia <- leveneTest(dados ~ grupo)
    print(">>>>>>>>>>>Teste de Homogeneidade de Variância:")
    print(teste_homogeneidade_variancia)

    # Teste de independência das observações (Durbin-Watson)
    modelo <- lm(dados ~ grupo)
    teste_independencia <- durbinWatsonTest(modelo)
    print(">>>>>>>>>>>Teste de Independência das Observações:")
    print(teste_independencia)

    # Verificar se os pressupostos são atendidos
    if (teste_normalidade$p.value > 0.05 & teste_homogeneidade_variancia$p.value > 0.05) {
      # Pressupostos atendidos, executar a ANOVA
      anova_resultado <- summary(aov(dados ~ grupo))
      print("")
      print(">>>>>>>>>>>ANOVA:")
      print(anova_resultado)

      # Verificar se a ANOVA é significativa
      if (anova_resultado[[1]][["Pr(>F)"]][[1]]< 0.05) {
        # ANOVA significativa, executar o teste de Tukey
        tukey_resultado <- TukeyHSD(aov(dados ~ grupo))
        print("")
        print('>>>>>>>>>>>Teste de Tukey:')
        tukey_resultado
      }
    } else {
      # Pressupostos não atendidos, executar o teste de Kruskal-Wallis
      kruskal_resultado <- kruskal.test(dados, grupo)
      print("")
      print(">>>>>>>>>>>Teste de Kruskal-Wallis:")
      print(kruskal_resultado)

      # Verificar se o teste de Kruskal-Wallis é significativo
      if (kruskal_resultado$p.value < 0.05) {
        # Teste de Kruskal-Wallis significativo, executar o teste de Dunn
        print("")
        print(">>>>>>>>>>>Teste de Dunn:")
        dunn_resultado <- dunn.test::dunn.test(dados, grupo)

      }
    }
  }
}
