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
library(rsconnect)


gentrification.df <- read.csv(file.choose(new = FALSE))


#Read in JSON file that includes the polygonal shapes of the neighborhoods
NYC.js <- geojson_read(file.choose(new = FALSE),what="sp")
#Test if it prints the outlines
colnames(NYC.js@data)[colnames(NYC.js@data)=="ntacode"] <- "GeoID"

NYC.js@data$id <- seq(0,194,by=1)
NYC.js@data <- merge(NYC.js@data,gentrification.df,by="GeoID",all=TRUE)
#add an id column for merging purposes

#Fortify and merge the two data sets
NYC.js.f <- fortify(NYC.js)
NYC.js.f <- merge(NYC.js.f,NYC.js@data,by="id",all=TRUE)


#GOOGLE Maps requires API key
register_google(key = "AIzaSyCB3s03JVUmb_cpbhWrt_BF52hWwxnHXT8", write = TRUE)

#Use data to layer outline over real NYC map (ggmap). Using GFactor2010 as fill
#2010
Outline10  <- geom_polygon_interactive(aes(long,lat,group=group,fill=GFactor2010.x,tooltip=sprintf("%s<br>%s",GeogName.x,GFactor2010.x)),data=NYC.js.f,colour = "black")
mapImage <- ggmap(get_googlemap(c(lon=-74.0060,lat=40.7128),scale=1,zoom=10),fullpage=TRUE,extent = "panel")
NYCMAP2010   <- mapImage+Outline10+labs(title = 'Gentrification by Neighborhood',subtitle = 'Based on 2010 Census Data')

Outline16  <- geom_polygon_interactive(aes(long,lat,group=group,fill=GFactor2016.x,tooltip=sprintf("%s<br>%s",GeogName.x,GFactor2016.x)),data=NYC.js.f,colour = "black")
mapImage <- ggmap(get_googlemap(c(lon=-74.0060,lat=40.7128),scale=1,zoom=10),fullpage=TRUE,extent = "panel")
NYCMAP2016   <- mapImage+Outline16+labs(title = 'Gentrification by Neighborhood',subtitle = 'Based on 2016 Census Data')

OutlineChange  <- geom_polygon_interactive(aes(long,lat,group=group,fill=GFactorChange.x,tooltip=sprintf("%s<br>%s",GeogName.x,GFactorChange.x)),data=NYC.js.f,colour = "black")
mapImage <- ggmap(get_googlemap(c(lon=-74.0060,lat=40.7128),scale=1,zoom=10),fullpage=TRUE,extent = "panel")
NYCMAPCHANGE   <- mapImage+OutlineChange+scale_fill_gradient(low = "#000000", high = "#ffff00")+labs(title = 'Gentrification by Neighborhood',subtitle = 'Based on 2010-16 Census Data')


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
    ggiraph(code=print(mapImage+geom_polygon_interactive(aes(long,lat,group=group,fill=NYC.js.f[,input$variable],tooltip=sprintf("%s<br>%s",NYC.js.f$GeogName,NYC.js.f[,input$variable])),data=NYC.js.f,colour = "black")+scale_fill_gradient(low = "#ffffff", high = "#FF0000")))
  })
  
}

