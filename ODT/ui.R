# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# server.R
# This is the server logic of this Shiny web application
# Outbreak Detection Tool v2
#
# Cambodia Malaria Outbreak Detection Tool
# Author: Olivier Celhay - olivier.celhay@gmail.com
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

library(shiny)
library(markdown)
library(leaflet)

shinyUI(fluidPage(
  
  fluidRow(HTML('<center><h4>Cambodia Malaria Outbreak Detection Tool</h4></center>')),
  
  fluidRow(column(3,
                  
                  # CNM logo            
                  img(src='./logo/cnm_logo.jpg', height = 140, width = 140), br(), br(),
                  
                  
                  # File Input
                  conditionalPanel(
                    condition="input.theTabs == 'TabPassword'",
                    fileInput("file_RData", label = NULL, accept = ".RData", buttonLabel = "Browse..."),
                    htmlOutput("text_test_upload")
                  ),
                  
                  # selection of a baseline range
                  uiOutput('YearSelect'),
                  
                  # selection of a Province, OD, HF
                  uiOutput('ProvinceSelector'),
                  uiOutput('ODSelector'),
                  uiOutput('HFSelector'),
                  
                  # selection of alert/outbreak levels, species and origin
                  conditionalPanel(
                    condition="input.theTabs == 'TabCountry' | input.theTabs == 'TabProvince' | input.theTabs == 'TabOD' | input.theTabs == 'TabHF' | input.theTabs == 'TabSeasonality'",
                    selectInput('outbreak', 'Definition of Alert/Outbreak Levels:', selected='who', c('High Sensitivty: 0.5/1 SD'='high', 'Standard Definition: 1/2 SD'='who', 'Low Sensitivty: 2/3 SD'='low')),
                    checkboxGroupInput('species', 'Select Species:', choices=c('Pf', 'Pv', 'Mix'), selected=c('Pf', 'Pv', 'Mix'), inline=T),
                    checkboxGroupInput('origins', 'Select Datasets:', choices=c('HIS', 'VMW'), selected=c('HIS', 'VMW'), inline=T)
                  ),
                  
                  # Logos
                  br(), br(), 
                  img(src='./logo/MORU_logo.jpg', height = 70),
                  br(), br(),
                  img(src='./logo/mc_logo.png', height = 68, width = 146)
                  
  ),
  
  column(9,   # right column
         tabsetPanel(type = "tabs", id='theTabs',
                     tabPanel('About', includeMarkdown('./www/markdown/password.md'), value='TabPassword'),
                     
                     tabPanel('Cambodia',
                              HTML('<h4>Country Outbreak Detection</h4>'),
                              plotOutput('countryPlot'),
                              leafletOutput('map', height=400, width='100%'), HTML('<small>The boundaries and names shown and the designation used on this map do not imply the expression of any opinion whatsoever concerning the legal status of any country, territory, city or area or its authorities, or concerning the delimitation of its frontiers or boundaries.</small>'),br(), br(),
                              'Table: comparison of the average monthly number of cases of the last quarter and previous year data', br(), br(),
                              DT::dataTableOutput('outbreak.table.pro', width='100%'), br(),
                              value='TabCountry'),
                     
                     tabPanel('Province',
                              HTML('<h4>Province Outbreak Detection</h4>'),
                              plotOutput('provincePlot'),
                              'Table: comparison of the average monthly number of cases of the last quarter and previous year data', br(), br(),
                              DT::dataTableOutput('outbreak.table.od', width='100%'), br(),
                              
                              value='TabProvince'),
                     tabPanel('OD',
                              HTML('<h4>OD Outbreak Detection</h4>'),
                              textOutput('tier'), br(),
                              plotOutput('districtPlot'),
                              'Table: comparison of the average monthly number of cases of the last quarter and previous year data', br(), br(),
                              DT::dataTableOutput('outbreak.table.hf', width='100%'), br(),
                              value='TabOD'),
                     
                     tabPanel('Health Facility',
                              HTML('<h4>Health Facility Outbreak Detection</h4>'),
                              plotOutput('HFPlot'),
                              value='TabHF'),
                     
                     tabPanel('Seasonality', 
                              br(),
                              HTML('<h5>Country level:</h5>'),
                              plotOutput('countryPlot2'),
                              br(),
                              HTML('<h5>Provincial level:</h5>'),
                              plotOutput('provincePlot2'),
                              HTML('<h5>Operational District level:</h5>'),
                              plotOutput("districtPlot2"),
                              value='TabSeasonality'),
                     
                     tabPanel('Read Me', includeMarkdown('./www/markdown/about.md'), value='TabAbout')
         )
  )
  )
)
)