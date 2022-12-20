

ui <- navbarPage("Gentrification in New York City",
                 # Boxes need to be put in a row (or column)
                 
                 tabPanel("2010", mainPanel(ggiraphOutput("plot2"))),
                 
                 tabPanel("2016", mainPanel(ggiraphOutput("plot3"))),
                 
                 tabPanel("Change over Time", mainPanel(ggiraphOutput("plot4"))),
                 
                 tabPanel("Interactive Map",
                          mainPanel(selectInput("variable","Variable:",choices = colnames(gentrification.df[-1:-3])),
                                    mainPanel(ggiraphOutput("plot5"))))
                 
                 
)

server <- function(input, output) {
  
  output$plot2 <- renderggiraph({
    ggiraph(code=print(NYCMAP2010))
  })
  
  output$plot3 <- renderggiraph({
    ggiraph(code=print(NYCMAP2016))
  })
  
  output$plot4 <- renderggiraph({
    ggiraph(code=print(NYCMAPCHANGE))
  })
  
  
  output$plot5 <- renderggiraph({
    ggiraph(code=print(mapImage+geom_polygon_interactive(aes(long,lat,group=group,fill=NYC.js.f[,input$variable],tooltip=sprintf("%s<br>%s",GeogName,NYC.js.f[,input$variable])),data=NYC.js.f,colour = "black")+scale_fill_gradient(low = "#ffffff", high = "#FF0000")))
  })
  
}

shinyApp(ui, server)
