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
library(shinythemes)

gentrification.df <- read.csv(file.choose(new = FALSE))


ui <- navbarPage(theme = shinytheme("flatly"),"Gentrification in New York City",
                 # Boxes need to be put in a row (or column)
                 
                 tabPanel("Change over Time", fillPage(mainPanel(ggiraphOutput("plot4"),height="100%"))),
                 
                 tabPanel("2010", fillPage(mainPanel(ggiraphOutput("plot2"),height="100%"))),
                 
                 tabPanel("2016", mainPanel(ggiraphOutput("plot3"))),
                 
                 tabPanel("Interactive Map",
                          mainPanel(selectInput("variable","Variable:",choices = colnames(gentrification.df[-1:-3])),
                                    mainPanel(ggiraphOutput("plot5"))))
                 
                 
)
