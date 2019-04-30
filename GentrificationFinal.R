
library(ggplot2)
library(tmap)    # for static and interactive maps
library(leaflet) # for interactive maps
library(mapview) # for interactive maps
library(R2HTML)
library(ggiraph)
library(sf)
library(geojsonR)
library(OpenStreetMap)
library(sp)
library(geojsonio)
library(ggmap)
library(dplyr)
library(shiny)
library(shinydashboard)


gentrification.df <- read.csv("C:\\Users\\aran0\\Documents\\Gentrification Data\\GentData.csv")



#Read in JSON file that includes the polygonal shapes of the neighborhoods
NYC.js <- geojson_read("C:\\Users\\aran0\\Documents\\Gentrification Data\\NTA map.geojson",what="sp")
#Test if it prints the outlines
colnames(NYC.js@data)[colnames(NYC.js@data)=="ntacode"] <- "GeoID"

NYC.js@data$id <- seq(0,194,by=1)
NYC.js@data <- merge(NYC.js@data,gentrification.df,by="GeoID",all=TRUE)
#add an id column for merging purposes

#Fortify and merge the two data sets
NYC.js.f <- fortify(NYC.js)
NYC.js.f <- merge(NYC.js.f,NYC.js@data,by="id",all=TRUE)


#GOOGLE Maps requires API key
register_google(key = "AIzaSyBVCg_aJcCEdoI8IbrpxVjSuG541LytOVc", write = TRUE)

#Use data to layer outline over real NYC map (ggmap). Using GFactor2010 as fill
#2010
Outline10  <- geom_polygon_interactive(aes(long,lat,group=group,fill=GFactor2010,tooltip=sprintf("%s<br>%s",NYC.js.f$GeogName,GFactor2010)),data=NYC.js.f,colour = "black")
mapImage <- ggmap(get_googlemap(c(lon=-74.0060,lat=40.7128),scale=1,zoom=10),extent = "panel")
NYCMAP2010   <- mapImage+Outline10+labs(title = 'Gentrification by Neighborhood',subtitle = 'Based on 2010 Census Data')

Outline16  <- geom_polygon_interactive(aes(long,lat,group=group,fill=GFactor2016,tooltip=sprintf("%s<br>%s",NYC.js.f$GeogName,GFactor2016)),data=NYC.js.f,colour = "black")
mapImage <- ggmap(get_googlemap(c(lon=-74.0060,lat=40.7128),scale=1,zoom=10),extent = "panel")
NYCMAP2016   <- mapImage+Outline16+labs(title = 'Gentrification by Neighborhood',subtitle = 'Based on 2016 Census Data')

OutlineChange  <- geom_polygon_interactive(aes(long,lat,group=group,fill=GFactorChange,tooltip=sprintf("%s<br>%s",NYC.js.f$GeogName,GFactorChange)),data=NYC.js.f,colour = "black")
mapImage <- ggmap(get_googlemap(c(lon=-74.0060,lat=40.7128),scale=1,zoom=10),extent = "panel")
NYCMAPCHANGE   <- mapImage+OutlineChange+scale_fill_gradient(low = "#000000", high = "#ffff00")+labs(title = 'Gentrification by Neighborhood',subtitle = 'Based on 2010-16 Census Data')


# in working directory:



ui <- dashboardPage(
  dashboardHeader(title = "Gentrification Project"),
  dashboardSidebar(),
  dashboardBody(
    # Boxes need to be put in a row (or column)
    
      mainPanel(plotOutput("plot0")),
      
      mainPanel(plotOutput("plot1")),
    
      mainPanel(plotOutput("plot10")),
      
      mainPanel(ggiraphOutput("plot2")),
    
      mainPanel(ggiraphOutput("plot3")),

      mainPanel(ggiraphOutput("plot4")),
      
      selectInput("variable","Variable:",choices = colnames(gentrification.df[-1:-3])),
      mainPanel(ggiraphOutput("plot5"))
    
  )
)

server <- function(input, output) {
  output$plot0 <- renderPlot({
    qplot(GFactor2010,Borough,data=gentrification.df,geom=c("boxplot"),fill=Borough,xlab="Gentrification Occuring",ylab="Boroughs",main= "Gentrification by Borough - 2010")
  })
  
  output$plot1 <- renderPlot({
    qplot(GFactor2016,Borough,data=gentrification.df,geom=c("boxplot"),fill=Borough,xlab="Gentrification Occuring",ylab="Boroughs",main= "Gentrification by Borough - 2016")
  })
  
  output$plot10 <- renderPlot({
    qplot(GFactorChange,Borough,data=gentrification.df,geom=c("boxplot"),fill=Borough,xlab="Gentrification Occuring Change",ylab="Boroughs",main= "Gentrification by Borough Over Time")
    
  })
  
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
    ggiraph(code=print(mapImage+geom_polygon_interactive(aes(long,lat,group=group,fill=NYC.js.f[,input$variable],tooltip=sprintf("%s<br>%s",NYC.js.f$GeogName,NYC.js.f[,input$variable])),data=NYC.js.f,colour = "black")+scale_fill_gradient(low = "#ffffff", high = "#FF0000")))
  })
  
  }

shinyApp(ui, server)

