# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# server.R
# This is the server logic of this Shiny web application
# Outbreak Detection Tool v2
# Last updated: 2017-10-13
#
# Cambodia Malaria Outbreak Detection Tool
# Author: Olivier Celhay - olivier.celhay@gmail.com
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# Load packages
library(shiny)
library(DT)
library(RColorBrewer)
library(ggplot2)
library(maptools)
library(leaflet)

library(dplyr)





# run only during app compilation
source('./www/scripts/outbreak_barplot.R', local=T)
source('./www/scripts/seasonal_barplot.R', local=T)
source('./www/scripts/datatable_variation.R', local=T)

shinyServer(function(input, output, session){
  
  
  # Initiate reactive values.
  no_data <- reactiveVal(TRUE)
  status <- reactiveVal("<div class='alert alert-danger'>Not yet any data.</div>")
  source_data <- reactiveVal(NULL)
  
  map <- reactiveVal(NULL)
  epi_country_reac <- reactiveVal(NULL)
  epi_province_reac <- reactiveVal(NULL)
  epi_od_reac <- reactiveVal(NULL)
  od_info_reac <- reactiveVal(NULL)
  epi_hf_reac <- reactiveVal(NULL)
  
  
  
  # Load .Rdata from input and update reactive values.
  observeEvent(input$file_RData,{
    
    # escape if there is no data
    if (is.null(input$file_RData)) return(NULL)
    
    # load data
    inFile <- input$file_RData
    file <- inFile$datapath
    load(file, envir = .GlobalEnv)
    
    # update reactive values
    no_data(FALSE)
    status(paste0("<br><div class='alert alert-info'>", "Data provided", " (generated on the ", date_generation_RData, ")"))
    source_data(paste0("Source of data: HMIS Cambodia, updated ", date_generation_RData))
    
    map(map_leaflet)
    epi_country_reac(epi_country)
    epi_province_reac(epi_province)
    epi_od_reac(epi_od)
    od_info_reac(od_info)
    epi_hf_reac(epi_hf)
  })
  
  
  # User Interface ---------------------------------------------------------------
  
  # Test Password
  # test_password <- reactiveValues(valid=FALSE, msg='<code>Please enter your password</code>')
  # observeEvent(input$submit_pwd, 
  #              ifelse(input$passwd==correct_password, 
  #                     {test_password$valid <- TRUE; test_password$msg <- '<span style="color:green">Correct Password</span>'},
  #                     {test_password$valid <- FALSE; test_password$msg <- '<code>Incorrect Password</code>'}
  #              ))
  
  # Message Password
  output$message_pwd <- renderText(test_password$msg)
  
  # selection of a province
  output$ProvinceSelector <- renderUI({
    if(no_data()) return(NULL)  # case there is no data
    conditionalPanel(condition="input.theTabs == 'TabProvince' | input.theTabs == 'TabOD' | input.theTabs == 'TabHF' | input.theTabs == 'TabSeasonality'",
                     selectInput('prov', 'Select a Province:', list_provinces))})
  
  # selection of an OD
  output$ODSelector <- renderUI({
    if(no_data()) return(NULL)  # case there is no data
    conditional.oper.district <- as.character(unique(subset(list_od, list_od$Name_Prov_E==input$prov)$Name_OD_E))
    conditionalPanel(condition="input.theTabs == 'TabOD'| input.theTabs == 'TabHF' | input.theTabs == 'TabSeasonality'", selectInput('conditional.oper.district', 'Select an Operational District:', choices=conditional.oper.district))})
  
  # selection of an Health Facility
  output$HFSelector <- renderUI({
    if(no_data()) return(NULL)  # case there is no data
    conditional.hf <- as.character(unique(subset(list_hf, list_hf$Name_Prov_E==input$prov & list_hf$Name_OD_E==input$conditional.oper.district)$Name_Facility_E))
    conditionalPanel(condition="input.theTabs == 'TabHF'", selectInput('conditional.hf', 'Select a Health Facility:', choices=conditional.hf))})
  
  
  # selection of years
  output$YearSelect <- renderUI({
    if(no_data()) return(NULL)  # case there is no data
    conditionalPanel(condition="input.theTabs == 'TabCountry' | input.theTabs == 'TabProvince' | input.theTabs == 'TabOD' | input.theTabs == 'TabHF' | input.theTabs == 'TabSeasonality'", sliderInput(inputId='years.baseline', label='Select baseline range:', min=min(list_years), max=max(list_years), value=c((max(list_years)-2), max(list_years)-1), step=1, sep='', ticks=T))})
  
  
  # Tabulations ---------------------------------------------------------------
  
  # Country level -------------------------
  
  dataset_country <- reactive({
    
    if(is.null(epi_country_reac())) return(NULL)
    
    df <- epi_country_reac() %>% 
      filter(Origin %in% origins) %>%
      group_by(Date, Year, Month) %>% 
      summarise(Pf=sum(Pf, na.rm=T), Pv=sum(Pv, na.rm=T), Mix=sum(Mix, na.rm=T)) %>%
      ungroup()
    
    if(is.null(input$species)) df[, 'Positive'] <- 0
    if(length(input$species)==1) df[, 'Positive'] <- df[, input$species]
    if(length(input$species)>1) df[, 'Positive'] <- apply(df[, input$species], 1, sum, na.rm=T)
    
    return(df)
  })
  
  # Outbreak plot of the country
  output$countryPlot <- renderPlot({
    
    if(no_data()) return(NULL)  # case there is no data
    
    outbreak_barplot(def.outbreak=input$outbreak, years.baseline=input$years.baseline[1]:input$years.baseline[2], species=input$species, origins=input$origins,
                     dataset=epi_country_reac(),
                     title=c('Cambodia', paste('Species: ', paste(input$species, collapse=', '), collapse=''), paste('Origin: ', paste(input$origins, collapse=', '), collapse='')))
  })
  
  # Map
  output$map <- renderLeaflet({
    if(no_data()) return(NULL)  # case there is no data
    map()
  })
  
  
  # Monthly barplot of the country
  output$countryPlot2 <- renderPlot({
    if(no_data()) return(NULL)  # case there is no data
    seasonal_barplot(years.baseline=input$years.baseline[1]:input$years.baseline[2], species=input$species, origins=input$origins, dataset=epi_country_reac(), 
                     title=paste(c('Cambodia', paste('Species: ', paste(input$species, collapse=', '), collapse=''), paste('Origin: ', paste(input$origins, collapse=', '), collapse='')), collapse='\n'))
    
  })
  
  
  # Provincial level -------------------------
  
  # Table of the Province last 3 months of data
  output$outbreak.table.pro <- DT::renderDataTable({
    if(no_data()) return(NULL)  # case there is no data
    datatable_variation(dataset=epi_province_reac(), level='Name_Prov_E', level_colname='Province', species=input$species, origin=input$origins)
  })
  
  # Table of the malaria cases of the Province
  output$morbidity.table.prov <- DT::renderDataTable({
    if(no_data()) return(NULL)  # case there is no data
    pro_variation_filter <- select(epi_od_reac(), Name_Prov_E==input$prov)
    datatable_variation(dataset=pro_variation_filter, level='Name_OD_E', level_colname='OD', species=input$species, origins=input$origins)
  })
  
  output$provincePlot2 <- renderPlot({
    if(no_data()) return(NULL)  # case there is no data
    seasonal_barplot(years.baseline=input$years.baseline[1]:input$years.baseline[2], species=input$species, 
                     origins=input$origins, subset_province=input$prov, dataset=epi_province_reac(), 
                     title=paste(c(paste(input$prov, 'Province'), paste('Species: ', paste(input$species, collapse=', '), collapse=''), paste('Origin: ', paste(input$origins, collapse=', '), collapse='')), collapse='\n'))
  })
  
  
  
  # Outbreak plot of the province
  output$provincePlot <- renderPlot({
    if(no_data()) return(NULL)  # case there is no data
    baseline <- input$years.baseline[1]:input$years.baseline[2]
    outbreak_barplot(def.outbreak=input$outbreak, years.baseline=baseline, species=input$species, 
                     origins=input$origins, subset_province=input$prov, dataset=epi_province_reac(), 
                     title=c(paste(input$prov, 'Province'), paste('Species: ', paste(input$species, collapse=', '), collapse=''), paste('Origin: ', paste(input$origins, collapse=', '), collapse='')))
  }) 
  
  
  # OD level -------------------------
  
  # Table of the OD last 3 months of data
  output$outbreak.table.od <- DT::renderDataTable({
    if(no_data()) return(NULL)  # case there is no data
    od_variation_filter <- filter(epi_od_reac(), Name_Prov_E==input$prov)
    datatable_variation(od_variation_filter, level='Name_OD_E', level_colname='OD', species=input$species, origins=input$origins)
  })
  
  # Message informing of the Tier of selected OD
  output$tier <- renderText({
    if(no_data()) return(NULL)  # case there is no data
    tier_od <- od_info_reac()$Tier[od_info_reac()$Name_OD_E==input$conditional.oper.district]
    if(is.na(tier_od)) tier_od <- 3
    if(tier_od == 1){text <- 'Operational District in Tier 1 area: strong evidence of artemisinin resistance.'}
    if(tier_od == 2){text <- 'Operational District in Tier 2 area: suspected artemisinin resistance.'}
    if(tier_od == 3){text <- 'Operational District in Tier 3 area: no evidence of artemisinin resistance.'}
    return(text)
  })
  
  
  # Outbreak plot of the OD
  output$districtPlot <- renderPlot({
    if(no_data()) return(NULL)  # case there is no data
    baseline <- input$years.baseline[1]:input$years.baseline[2]
    outbreak_barplot(def.outbreak=input$outbreak, years.baseline=baseline, species=input$species, origins=input$origins, subset_province=input$province, 
                     subset_od=input$conditional.oper.district, dataset=epi_od_reac(), 
                     title=c(paste(input$conditional.oper.district, 'OD'), paste('Species: ', paste(input$species, collapse=', '), collapse=''), paste('Origin: ', paste(input$origins, collapse=', '), collapse='')))
  })
  
  # Monthly barplot of the OD
  output$districtPlot2 <- renderPlot({
    if(no_data()) return(NULL)  # case there is no data
    seasonal_barplot(years.baseline=input$years.baseline[1]:input$years.baseline[2], species=input$species, origins=input$origins, 
                     subset_od=input$conditional.oper.district, dataset=epi_od_reac(), 
                     title=paste(c(paste(input$conditional.oper.district, 'OD'), paste('Species: ', paste(input$species, collapse=', '), collapse=''), paste('Origin: ', paste(input$origins, collapse=', '), collapse='')), collapse='\n'))
  })
  
  
  # Health Facility Level -------------------------
  
  # Table of the HF last 3 months of data
  output$outbreak.table.hf <- DT::renderDataTable({
    if(no_data()) return(NULL)  # case there is no data
    prov <- input$prov
    od <- input$conditional.oper.district
    hf_variation_filter <- filter(epi_hf_reac(), Name_Prov_E==prov, Name_OD_E==od)
    datatable_variation(hf_variation_filter, level='Name_Facility_E', level_colname='Health Facility', species=input$species, origins=input$origins)
  })
  
  # Outbreak plot of the HF
  output$HFPlot <- renderPlot({
    if(no_data()) return(NULL)  # case there is no data
    baseline <- input$years.baseline[1]:input$years.baseline[2]
    outbreak_barplot(def.outbreak=input$outbreak, years.baseline=baseline, species=input$species, origins=input$origins, 
                     subset_province=input$province, subset_od=input$conditional.oper.district, subset_hf=input$conditional.hf, dataset=epi_hf_reac(), 
                     title=c(paste(input$conditional.hf, 'Health Facility'), paste('Species: ', paste(input$species, collapse=', '), collapse=''), paste('Origin: ', paste(input$origins, collapse=', '), collapse='')))
  })
  
})