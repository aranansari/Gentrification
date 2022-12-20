library(ggplot2)
library(tmap)    # for static and interactive maps3
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
library(shinythemes)


rsconnect::setAccountInfo(name='aranansari',
                          token='44DFE0D9A8F8E02520CB39D8D488D553',
                          secret='/0IoCo5c6e7Ss/hVrND3VFQwItx15fNX7Vt74FeM')



#GOOGLE Maps requires API key
register_google(key = "AIzaSyCB3s03JVUmb_cpbhWrt_BF52hWwxnHXT8", write = TRUE)

#Use data to layer outline over real NYC map (ggmap). Using GFactor2010 as fill
#2010
Outline10  <- geom_polygon_interactive(aes(long,lat,group=group,fill=GFactor2010,tooltip=sprintf("%s<br>%s",GeogName,GFactor2010)),data=subset(NYC.js.f,lat >=-60 & lat <= 90),colour = "black")
mapImage <- ggmap(get_googlemap(c(lon=-74.0060,lat=40.7128),scale=1,zoom=10),fullpage=TRUE,extent = "panel")
NYCMAP2010   <- mapImage+Outline10+labs(title = 'Gentrification by Neighborhood',subtitle = 'Based on 2010 Census Data')

Outline16  <- geom_polygon_interactive(aes(long,lat,group=group,fill=GFactor2016,tooltip=sprintf("%s<br>%s",GeogName,GFactor2016)),data=subset(NYC.js.f,lat >=-60 & lat <= 90),colour = "black")
mapImage <- ggmap(get_googlemap(c(lon=-74.0060,lat=40.7128),scale=1,zoom=10),fullpage=TRUE,extent = "panel")
NYCMAP2016   <- mapImage+Outline16+labs(title = 'Gentrification by Neighborhood',subtitle = 'Based on 2016 Census Data')

OutlineChange  <- geom_polygon_interactive(aes(long,lat,group=group,fill=GFactorChange,tooltip=sprintf("%s<br>%s",GeogName,GFactorChange)),data=subset(NYC.js.f,lat >=-60 & lat <= 90),colour = "black")
mapImage <- ggmap(get_googlemap(c(lon=-74.0060,lat=40.7128),scale=1,zoom=10),fullpage=TRUE,extent = "panel")
NYCMAPCHANGE   <- mapImage+OutlineChange+scale_fill_gradient(low = "#000000", high = "#ffff00")+labs(title = 'Gentrification by Neighborhood',subtitle = 'Based on 2010-16 Census Data')


shinyApp(ui, server)
