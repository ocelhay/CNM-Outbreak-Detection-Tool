
outbreak_barplot <- function(def.outbreak, years.baseline, species, origins, subset_province=NULL, subset_od=NULL, subset_hf=NULL, dataset, title){
  
  # Alert/Outbreak thresholds
  if(def.outbreak == 'low'){a <- 2; o <- 3}
  if(def.outbreak == 'who'){a <- 1; o <- 2}
  if(def.outbreak == 'high'){a <- 0.5; o <- 1}
  
  # Filters
  if(!is.null(subset_province)) dataset <- dplyr::filter(dataset, Name_Prov_E==subset_province)
  if(!is.null(subset_od)) dataset <- dplyr::filter(dataset, Name_OD_E==subset_od)
  if(!is.null(subset_hf)) dataset <- dplyr::filter(dataset, Name_Facility_E==subset_hf)
  
  
  dataset <- dplyr::filter(dataset, Origin %in% origins) %>% 
    group_by(Date, Year, Month) %>% 
    summarise(Pf=sum(Pf, na.rm=T), Pv=sum(Pv, na.rm=T), Mix=sum(Mix, na.rm=T)) %>%
    ungroup()
  
  if(is.null(species)) dataset[, 'Positive'] <- 0
  if(length(species)==1) dataset[, 'Positive'] <- dataset[, species]
  if(length(species)>1) dataset[, 'Positive'] <- apply(dataset[, species], 1, sum, na.rm=T)
  
  if(sum(dataset$Positive, na.rm=T)>0){
    year.baseline.max <- max(years.baseline)
    n.months <- length(unique(dataset$Date))
    n.years <- (n.months-1) %/% 12 #need data complete up to the following January to have the year 'complete'
    last.month <- n.months %% 12
    start <- min(dataset$Date)
    end <- max(dataset$Date)
    dataset.base <- dplyr::filter(dataset, Year %in% years.baseline)
    dataset.ave <- tapply(dataset.base$Positive, dataset.base$Month, mean)
    dataset.sd <- sd(dataset.base$Positive)
    
    base_line <- c(rep(dataset.ave, n.years), dataset.ave[1:last.month])
    alert_line <- c(rep(dataset.ave+a*dataset.sd, n.years), dataset.ave[1:last.month]+a*dataset.sd)
    outbreak_line <- c(rep(dataset.ave+o*dataset.sd, n.years), dataset.ave[1:last.month]+o*dataset.sd)
    
    
    # Definition colors
    col <- rep('white', n.months)
    col[dataset$Year > year.baseline.max & dataset$Positive < alert_line]  <- BYR[1]
    col[dataset$Year > year.baseline.max & dataset$Positive > alert_line] <- BYR[2]
    col[dataset$Year > year.baseline.max & dataset$Positive > outbreak_line] <- BYR[3]
    col[dataset$Year %in% years.baseline] <- 'light grey'
    
    b <- barplot(dataset$Positive, col=col, main=title, cex.main=1.2)
    axis(1, at=b[6+(0:n.years*12)], labels=dataset$Year[6+(0:n.years*12)], cex=1, tick=F)
    axis(1, at=b[c(1+(0:n.years*12), n.months)], cex=1, labels=F)
    axis(1, at=b[1], labels='Jan.', cex.axis=1, padj=-2)
    axis(1, at=b[n.months], labels=month.abb[last.month], cex.axis=1, padj=-2)
    lines(b, base_line, col='black', lwd=2, lty=5)
    lines(b, alert_line, col=BYR[2], lwd=2, lty=5)
    lines(b, outbreak_line, col=BYR[3], lwd=2, lty=5)
    
    legend('bottomleft', legend=c('Baseline', paste('Alert threshold: ', a, 'SD'), paste('Outbreak threshold: ', o, 'SD')), col=c('black', BYR[2:3]), lwd=2, lty=5, cex=1.2)
  }
}