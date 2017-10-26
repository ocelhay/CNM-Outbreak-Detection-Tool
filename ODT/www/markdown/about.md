
#### Alert/Outbreak detection

The main purpose of the malaria outbreak detection tool is to help visualise epidemiological trends and to detect unusual increases in the number of malaria cases at the Provincial, OD or Health Facility level. This is achieved in 3 phases:


 1. **Definition of a 'reference' disease baseline.** In the left panel, year or multiple years can be selected to use as baseline, e.g. the numbers of cases for the months of *Jan, Feb, ..., Dec* during this period are used to define a monthly 'Average Baseline', which is marked by a black dashed line in the graphic. 
 
 2. **Selection of sensitivity warning/alert threshold and creation of warning/alert thresholds for post-baseline data.** Using the baseline described above, and pooling all months of data together, [Standard Deviation](https://en.wikipedia.org/wiki/Standard_deviation) (SD) of the series is computed.
 In the left panel, three options offering different levels of sensitivity to define alert/outbreak levels can be used:
  - the "Standard definition" sets "Baseline + 1 SD" as the alert threshold and "Baseline + 2 SD" as the outbreak threshold. This is the more standard definition.
  - "High sensitivity" sets "Baseline + 0.5 SD" as the alert threshold and "Baseline + 1 SD" as the outbreak threshold. These thresholds would typically be used in areas where an increase in the number of malaria cases is considered a great threat.
  - "Low sensitivity" sets "Baseline + 2 SD" as the alert threshold and "Baseline + 3 SD" as the outbreak threshold. This option could be used to detect only the most severe outbreaks in reported malaria cases.
  
 3. **Comparison of current surveillance data to warning/alert thresholds to detect when number of cases is above normal.** Bars showing the monthly numbers of malaria cases are then coloured based on their relation to the thresholds:
  - values below the alert threshold are coloured in blue,
  - values above the alert threshold are flagged and coloured in yellow,
  - values above the outbreak threshold are flagged and coloured in red.



#### Discussion on Alert/Outbreak detection

A number of issues concerning how best to construct a 'reference' disease baseline have yet to be fully resolved. For example, what is the minimum number of years of data required to develop a reliable baseline? Should the time period used to estimate baseline lengthen with each year of new data, or should older data be discarded? Should data from known epidemic years be omitted from the baseline calculation? Based on local knowledge, whether some years should be discarded due to exceptional events?*Selecting at least the last 2 previous years will offer more robust results.*

Discussion is also ongoing about what should be the appropriate warning/alert threshold level. The "Standard definition" may be the default choice, but other choices could be more appropriate depending on the geographical area and the local factors related to transmission, such as the level of artemisnin resistance. For every OD selected, the artemisinin resistance tier is indicated above the Alert/Outbreak detection graph.


#### Credits

- Version 2.0. Updated in October 2017 with technical support from MORU and financial support form BMGF.
- Version 1.0. Developed with technical support from Malaria Consortium and financial support from Global Fund/RAI.

[Technical support mail.](mailto:olivier.celhay@gmail.com)


#### Software

This tool is built on open-source, free software:

 - [R Core Team (2014). R: A language and environment for statistical computing. R Foundation for Statistical Computing, Vienna, Austria.](http://www.R-project.org/.) 
 - [Winston Chang (2015). Shiny: Web Application Framework for R.](http://CRAN.R-project.org/package=shiny)
 - [Leaflet, a JavaScript library for interactive maps](http://leafletjs.com/)
 - [Datable table plug-in for jQuery](https://www.datatables.net/)
 - [H. Wickham. ggplot2: elegant graphics for data analysis. Springer New York, 2009.](ggplot2.org)
