Ralef: Automatizando as coisas no R
================

## Sobre o Ralef

Esse pacote tem como objetivo automatizar trabalhos no R que geralmente
levam um considerável tempo 😅. O Ralef permite realizar análises de
forma automatizada selecionando as variáveis desejadas. Além disso, esse
pacote permite a criação de gráficos com ggplot2 através da seleção de
variáveis. Tudo isso em uma interface simples que é apresentada. 🙌

## Quais análises o pacote permite automatizar?

Até o momento, foram implementadas as opções de realizar o teste t,
Mann-Whitney, Anova e Kruskal-Wallis. Isso de forma automatizada. O
pacote verifica os pressupostos e decide qual teste deve ser realizado.

## Como instalar

``` r
# Caso não tenha os pacotes instalados, remover o símbolo # antes das funções (install.packages).
# install.packages("devtools")
require(devtools)
# install_github("alefjonathan29/Ralef", force= T)
require(Ralef)
```

## Exemplo de uso das funções:

### Executando no R:

``` r
# Substitua iris pelo nome do seu dataset e os nomes após o $ pelo nome da 
# coluna que quer comparar. Atenção: A primeira coluna deve ser uma coluna 
# numérica e a segunda categórica. Caso tenha uma coluna numérica (ex: anos 
# de coleta que devem ser comparados) é necessário converte-la para fator 
# (exemplo: dados$anos <- as.factor(dados$ano)).

testar_Ralef(iris$Sepal.Width, iris$Species) 
```

    ## Loading required package: shiny

    ## Loading required package: rstatix

    ## 
    ## Attaching package: 'rstatix'

    ## The following object is masked from 'package:stats':
    ## 
    ##     filter

    ## Loading required package: car

    ## Loading required package: carData

    ## Loading required package: tidyverse

    ## ── Attaching packages ─────────────────────────────────────── tidyverse 1.3.1 ──

    ## ✔ ggplot2 3.4.2     ✔ purrr   1.0.1
    ## ✔ tibble  3.2.1     ✔ dplyr   1.1.2
    ## ✔ tidyr   1.3.0     ✔ stringr 1.5.0
    ## ✔ readr   2.1.1     ✔ forcats 1.0.0

    ## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::filter() masks rstatix::filter(), stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()
    ## ✖ dplyr::recode() masks car::recode()
    ## ✖ purrr::some()   masks car::some()

    ## [1] ">>>>>>>>>>>Teste de Normalidade:"
    ## 
    ##  Shapiro-Wilk normality test
    ## 
    ## data:  dados
    ## W = 0.98492, p-value = 0.1012
    ## 
    ## [1] ">>>>>>>>>>>Teste de Homogeneidade de Variância:"
    ## 
    ##  Bartlett test of homogeneity of variances
    ## 
    ## data:  dados and grupo
    ## Bartlett's K-squared = 2.0911, df = 2, p-value = 0.3515
    ## 
    ## [1] ">>>>>>>>>>>Teste de Independência das Observações:"
    ##  lag Autocorrelation D-W Statistic p-value
    ##    1      0.06040443      1.878846   0.312
    ##  Alternative hypothesis: rho != 0
    ## [1] ""
    ## [1] ">>>>>>>>>>>ANOVA:"
    ##              Df Sum Sq Mean Sq F value Pr(>F)    
    ## grupo         2  11.35   5.672   49.16 <2e-16 ***
    ## Residuals   147  16.96   0.115                   
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## [1] ""
    ## [1] ">>>>>>>>>>>Teste de Tukey:"

    ##   Tukey multiple comparisons of means
    ##     95% family-wise confidence level
    ## 
    ## Fit: aov(formula = dados ~ grupo)
    ## 
    ## $grupo
    ##                        diff         lwr        upr     p adj
    ## versicolor-setosa    -0.658 -0.81885528 -0.4971447 0.0000000
    ## virginica-setosa     -0.454 -0.61485528 -0.2931447 0.0000000
    ## virginica-versicolor  0.204  0.04314472  0.3648553 0.0087802

### Criando a interface que permite selecionar as variáveis e criar o gráfico em ggplot2:

``` r
#Substitua iris pelo nome do seu dataset.

criar_interface(iris) 
```

<img src="imagens/imagem1.jpg" />
