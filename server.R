#---- Analyse des stocks pertinents Ecolabel Pêche Durable  ----
#
# Interface Shiny - fichier server
#
# Code written by: 
#         Sébastien Metz - Sakana Consultants
# Initial Code: August 2019
#
shinyServer(function(input, output, session) 
{
  output$tabKobe <- renderTable(tabKobePT, digits = 0 )
  
  output$textePR1 <- renderUI({   
    HTML(textePR1)
  }) 
  
  observeEvent(input$stockID, {
  
  ICESredux <- subset(dataICES, nomStock == input$stockID)
  ICESredux <- subset(ICESredux, Year > 1999 & Year <= lastYear)
  ICESlast <- subset(ICESredux, Year == as.character(lastYear))
  
  indexBmax <- ceiling(round(max(ICESredux$indexB)*2))/2 + 0.5
  indexFmax <- ceiling(round(max(ICESredux$indexF)*2))/2 + 0.5
  
  indexBmax <- ifelse(indexBmax < 2,
                      2,
                      indexBmax)
  indexFmax <- ifelse(indexFmax < 2,
                      2,
                      indexFmax)
  indexBmax <- ifelse(is.na(indexBmax),
                      2,
                      indexBmax)
  indexFmax <- ifelse(
    is.na(indexFmax),
    2,
    indexFmax
  )
  
  # Fishing mortality
  Mortality <- ICESredux %>%
    select(Year, F, Flim, Fpa, FMSY) %>%
    gather(key = "variable", value = "value", -Year)
  Mortality$variable <- factor(Mortality$variable, levels = c("F", "Flim", "Fpa", "FMSY"))
  
  Mortality2 <- ICESredux %>% 
    select(Year, Low_FishingPressure, High_FishingPressure)
  
  # stock size
  stock <- ICESredux %>%
    select(Year, stock, Blim, Bpa, MSYBtrigger) %>%
    gather(key = "variable", value = "value", -Year)
  stock$variable <- factor(stock$variable, levels = c("stock", "Blim", "Bpa", "MSYBtrigger"))
  
  Stock2 <- ICESredux %>% 
    select(Year, Low_StockSize, High_StockSize)
  
  # Graph mortality
  gr_F <- ggplot() +
    geom_ribbon(
      data = Mortality2,
      aes(x = Year,
          ymin = Low_FishingPressure, 
          ymax = High_FishingPressure),
      col = "cadetblue",
      fill = "cadetblue1") +
    geom_line(
      data = Mortality,
      aes(x = Year,
          y = value,
          color = variable, 
          linetype = variable)) +
    scale_colour_manual(
      values=c("blue4", "brown", "blueviolet", "chartreuse4")) +
    theme(legend.position = "bottom",
          legend.title=element_blank()) +
    labs(x= "Année", y = "Mortalité par pêche") 

  # Graph biomass
  gr_B <- ggplot() +
    geom_ribbon(
      data = Stock2,
      aes(x = Year,
          ymin = Low_StockSize, 
          ymax = High_StockSize),
      col = "darkolivegreen3",
      fill = "darkolivegreen1") +
    geom_line(
      data = stock,
      aes(x = Year,
          y = value,
          color = variable, 
          linetype = variable)) +
    scale_colour_manual(
      values=c("seagreen", "brown", "blueviolet", "chartreuse4")) +
    theme(legend.position = "bottom",
          legend.title=element_blank()) +
    labs(x= "Année", y = "stock index") 
  
  # Graph Kobe
  gr_K <- ggplot() +
    geom_rect(
      aes(
        xmin = 0, 
        ymin = 0, 
        xmax = 1, 
        ymax = 1),
      fill = "orange")+
    geom_rect(
      aes(
        xmin = 0, 
        ymin = 1, 
        xmax = 1, 
        ymax = indexFmax),
      fill = "red")+
    geom_rect(
      aes(
        xmin = 1, 
        ymin = 1, 
        xmax = indexBmax, 
        ymax = indexFmax),
      fill = "yellow")+
    geom_rect(
      aes(
        xmin = 1, 
        ymin = 0, 
        xmax = indexBmax, 
        ymax = 1),
      fill = "green")+
    geom_path(
      data = ICESredux,
      aes(x = indexB,
          y = indexF)) + 
    geom_point(
      data = ICESredux,
      aes(x = indexB, 
          y = indexF)) +
    geom_point(
      data = ICESlast,
      aes(x = indexB,
          y = indexF),
      col = "black",
      fill = "white",
      shape = 23, 
      size = 3,
      stroke = .5) +
    labs(x= "Index B (=B/BMSY)", y = "Index F (=F/FMSY)") 

  output$gr_B <- renderPlot({plot(gr_B)})
  output$gr_F <- renderPlot({plot(gr_F)})
  output$gr_K <- renderPlot({plot(gr_K)})
  }
  )
}
)