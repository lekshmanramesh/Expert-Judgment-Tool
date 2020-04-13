#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
setwd("D:\\Lekshman\\IRRBB Modelling\\mortgage ejt")

library(shiny)
library(readxl)
library(ggplot2)
library(gridExtra)
library(dplyr)
library(shinyjs)
library(scales)
library(tidyr)
# Define UI for application that draws a histogram
shinyUI(fluidPage(
  useShinyjs(),
  # Application title
  titlePanel("Fixed Mortgage Share Among Originations"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      div(
        id = "form",
       sliderInput("intercept",
                   "Intercept",
                   min = -1,
                   max = 1,
                   value = 0.45615,
                   step=0.01),
       sliderInput("libor_3m",
                   "LIBOR 3M",
                   min = -1,
                   max = 1,
                   value = 0.04214,
                   step=0.01),
       sliderInput("swap_5y",
                   "SWAP 5Y Regime 1",
                   min = -1,
                   max = 1,
                   value = -0.10613,
                   step=0.01),
       sliderInput("bp1",
                   "Break Point 1 in %",
                   min = -2,
                   max = 5,
                   value = -0.079,
                   step=0.01),
       sliderInput("swap_5y_u1",
                   "SWAP 5Y Regime 2",
                   min = -1,
                   max = 1,
                   value = 0.22783,
                   step=0.01),
       sliderInput("bp2",
                   "Break Point 2 in %",
                   min = -2,
                   max = 5,
                   value = 1.25,
                   step=0.01),
       sliderInput("swap_5y_u2",
                   "SWAP 5Y Regime 3",
                   min = -1,
                   max = 1,
                   value = -0.29,
                   step=0.01)
      ),
      actionButton("resetAll", "Reset all")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       plotOutput("plotgraph1"),
       plotOutput("plotgraph2")
    )
  )
))
