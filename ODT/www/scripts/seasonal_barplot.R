
seasonal_barplot <- function(years.baseline, species, origins, subset_province=NULL, subset_od=NULL, subset_hf=NULL, dataset, title=''){
  
  if(!is.null(subset_province)) dataset <- subset(dataset, Name_Prov_E==subset_province)
  if(!is.null(subset_od)) dataset <- subset(dataset, Name_OD_E==subset_od)
  if(!is.null(subset_hf)) dataset <- subset(dataset, Name_Facility_E==subset_hf)
    
  dataset <- filter(dataset, Origin %in% origins, Year %in% years.baseline) %>% group_by(Date, Year, Month) %>% summarise(Pf=sum(Pf, na.rm=T), Pv=sum(Pv, na.rm=T), Mix=sum(Mix, na.rm=T))
    
    if(is.null(species)) dataset[, 'Positive'] <- 0
    if(length(species)==1) dataset[, 'Positive'] <- dataset[, species]
    if(length(species)>1) dataset[, 'Positive'] <- apply(dataset[, species], 1, sum, na.rm=T)
  

  par(mar=c(5.1, 4.1, 4.1, 2.1))
  ggplot(dataset, aes(factor(Month), Positive, fill=factor(Year))) + labs(title=title) + geom_bar(stat='identity', position='dodge') + scale_fill_brewer('Year', palette='Set1') + xlab('Month') + ylab('Confirmed Malaria Cases') + theme(axis.text=element_text(size=rel(1.2)), axis.title=element_text(size=rel(1.2)), plot.title=element_text(size=rel(1.2), face="bold"), legend.text=element_text(size=rel(1.2)), legend.title=element_text(size=rel(1.2)))}