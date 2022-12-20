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

ui <- navbarPage("Gentrification in New York City",
                 # Boxes need to be put in a row (or column)
                 
                 tabPanel("2010", mainPanel(girafeOutput("plot2"))),
                 
                 tabPanel("2016", mainPanel(girafeOutput("plot3"))),
                 
                 tabPanel("Change over Time", mainPanel(girafeOutput("plot4"))),
                 
                 tabPanel("Interactive Map",
                          mainPanel(selectInput("variable","Variable:",choices = colnames(gentrification.df[-1:-3])),
                                    mainPanel(girafeOutput("plot5"))))
                 
                 
)
