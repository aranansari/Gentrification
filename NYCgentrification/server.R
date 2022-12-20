knitr::opts_chunk$set(echo = TRUE)
library(ggplot2)
library(tmap)    # for static and interactive maps
library(leaflet) # for interactive maps
library(mapview) # for interactive maps
library(ggiraph)
library(sf)
library(geojsonR)
library(sp)
library(geojsonio)
library(ggmap)
library(dplyr)
library(shiny)
library(shinydashboard)


#Read in master data
gentrification.df <- read.csv("GentData.csv")

#Read in JSON file that includes the polygonal shapes of the neighborhoods
NYC.js <- geojson_read("NTA map.geojson",what="sp")
#Test if it prints the outlines
colnames(NYC.js@data)[colnames(NYC.js@data)=="ntacode"] <- "GeoID"

NYC.js@data$id <- seq(0,194,by=1)
NYC.js@data <- merge(NYC.js@data,gentrification.df,by="GeoID",all=TRUE)
#add an id column for merging purposes

#Fortify and merge the two data sets
NYC.js.f <- fortify(NYC.js)
NYC.js.f <- merge(NYC.js.f,NYC.js@data,by="id",all=TRUE)

server <- function(input, output) {
  
  output$plot2 <- renderGirafe({
    girafe(code=print(NYCMAP2010))
  })
  
  output$plot3 <- renderGirafe({
    girafe(code=print(NYCMAP2016))
  })
  
  output$plot4 <- renderGirafe({
    girafe(code=print(NYCMAPCHANGE))
  })
  
  output$plot5 <- renderGirafe({
    girafe(code=print(mapImage+geom_polygon_interactive(aes(long,lat,group=group,fill=NYC.js.f[input$variable],tooltip=sprintf("%s<br>%s",GeogName,NYC.js.f[,input$variable])),data=subset(NYC.js.f,lat >=-60 & lat <= 90),colour = "black")+scale_fill_gradient(low = "#ffffff", high = "#FF0000")))
  })
  
}
