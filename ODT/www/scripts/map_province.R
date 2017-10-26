map_province <- function(dataset, level='Name_Prov_E', species=c('Pf', 'Pv', 'Mix'), origins=c('HIS', 'VMW')){
  
  dataset <- filter(dataset, Origin %in% origins) # select HIS, VMW
  dataset <- dataset %>% group_by_(level, 'Date', 'Year', 'Month') %>% summarise(Pf=sum(Pf, na.rm=T), Pv=sum(Pv, na.rm=T), Mix=sum(Mix, na.rm=T), 'Year')
  
  if(length(species)==0) dataset[, 'Positive'] <- 0
  if(length(species)==1) dataset[, 'Positive'] <- dataset[, species]
  if(length(species)>1) dataset[, 'Positive'] <- apply(dataset[, species], 1, sum, na.rm=T)
  
  if(sum(dataset$Positive, na.rm=T)>0){
    
  last_Q <- dataset %>% group_by_(level) %>% top_n(3, Date)
  last_Q_string <- last_Q %>% group_by_(level) %>% summarise(Q_string=paste(Month, Year, sep='/', collapse=', '))
    
  last_Y <- dataset %>% group_by_(level) %>% top_n(15, Date) %>% arrange(desc(Date)) %>% do(tail(., 3)) %>% arrange(Date)
  last_Y_string <- last_Y %>% group_by_(level) %>% summarise(Y_string=paste(Month, Year, sep='/', collapse=', '))
  last_Q <- last_Q %>% summarise(mean_last_Q=ceiling(mean(Positive, na.rm=T)))
  last_Y <- last_Y %>% summarise(mean_last_Y=floor(mean(Positive, na.rm=T)))
    
  dataset_variation <- full_join(last_Y, last_Q, by=level) %>% full_join(last_Q_string, by=level) %>% full_join(last_Y_string, by=level) %>% mutate(pct_increase_positive = round((mean_last_Q - mean_last_Y)/mean_last_Y, 2))
  dataset_variation$pct_increase_positive[dataset_variation$mean_last_Y==0 & dataset_variation$mean_last_Q > 0] <- Inf
  dataset_variation$pct_increase_positive[dataset_variation$mean_last_Y > 0 & dataset_variation$mean_last_Q==0] <- -1

  dataset_variation$color <- 'light grey'
  dataset_variation$color[dataset_variation$pct_increase_positive <= 0] <- '#a6d96a'
  dataset_variation$color[dataset_variation$pct_increase_positive >= 0] <- '#fdae61'
  dataset_variation$color[dataset_variation$pct_increase_positive >= 0.5] <- '#d7191c'


# Add province names to the map that match with the list of provinces in the HIS/VMW files
cambodia_shp$Province <- list_prov[c(1:8, 10, 9, 11, 14, 21, 12, 13, 15, 18, 16, 17, 19, 20, 22, 23, 24)]
cambodia_shp@data <- left_join(cambodia_shp@data, dataset_variation, by=c('Province'='Name_Prov_E'))
cambodia_shp$lon <- coordinates(cambodia_shp)[,1]
cambodia_shp$lat <- coordinates(cambodia_shp)[,2]
popup_province <- paste0(cambodia_shp$Province, ' province: <br>', paste0(100*cambodia_shp$pct_increase_positive, '%'))

map <- leaflet(cambodia_shp) %>% 
  addTiles() %>%
  addPolygons(stroke=T, fillOpacity = 0.5, color=cambodia_shp$color, dashArray=6, weight=2, popup=popup_province) %>%
  addLegend('bottomright', colors=c('#a6d96a', '#fdae61', '#d7191c'), labels=c('Decrease', '1 to 50% increase', 'Over 50% increase'), title=paste0('Percentage change<br>Baseline/Latest Quarter<br>', paste(species, collapse='+'), ', ', paste(origins, collapse='+')), opacity=1)
return(map)
  }
}

