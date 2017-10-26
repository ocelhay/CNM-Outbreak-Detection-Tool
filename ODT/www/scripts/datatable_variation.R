datatable_variation <- function(dataset, level, level_colname='column name here', species, origins){
  
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

    datatable(dataset_variation[, c(1, 5, 2, 4, 3, 6)], colnames=c(level_colname, 'Baseline', 'Average monthly cases, baseline', 'Latest Quarter', 'Average monthly cases, latest quarter', 'Percentage Change'), filter = 'top', rownames=F, options=list(pageLength=5, searching=T)) %>% formatPercentage('pct_increase_positive') %>% formatStyle('pct_increase_positive', fontWeight = 'bold', backgroundColor=styleInterval(c(0, 0.5), c('#a6d96a', '#fdae61', '#d7191c')))
  }
}