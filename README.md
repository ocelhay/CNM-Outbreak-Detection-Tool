# CNM Outbreak Detection Tool

The CNM Outbreak Detection Tool can be launched directly from the App folder. Simply navigate through the folder and double click on the file: “_DOUBLE CLICK TO LAUNCH APP”
The App has been tested on Windows 7, 8.1 and 8.2 (x64 architecture) with Chrome browser.

## Intoduction

The main purpose of the malaria Outbreak Detection Tool (ODT) is to help analyse epidemiological trends in Cambodia and to detect unusual increases in the number of malaria cases at the Provincial, Operational District (OD) and Health Facility level. 


## ODT Framework

The ODT is built on the R/Shiny platform. R Statistical Software, often simply called ‘R’ is a free software environment for statistical computing and graphics. Shiny is an open source R package that provides an elegant and powerful web framework for building web applications using R.  In addition to these, additional R libraries are used to produce maps and tables that are integrated to the Shiny App.
All solutions used are open-source, free software and can be obtained in the listed websites:

- R Core Team (2014). R: A language and environment for statistical computing. R Foundation for Statistical Computing, Vienna, Austria. http://www.R-project.org/.
- Winston Chang (2015). Shiny: Web Application Framework for R. R package version 0.11. http://CRAN.R-project.org/package=shiny
- Leaflet, a JavaScript library for interactive maps: http://leafletjs.com 
- Datable table plug-in for jQuery: https://www.datatables.net/
- H. Wickham. ggplot2: elegant graphics for data analysis. Springer New York, 2009: http://ggplot2.org 


## ODT Application Format

he ODT, as any other shiny application, is essentially built using two R scripts that communicate with each other: a user interface script (ui.R), which controls the layout and appearance of the application; and a server script (server.R), incorporating instructions for user input, processing data, and output by utilizing the R language and functions from user installed packages. In addition to these scripts, the ODT also comprises a folder (www) with data and additional elements required for the application to run.


The application folder contains the following elements:

- server.R is the  Shiny server R script.
- ui.R is the Shiny user interface R script.
- www folder with the followings sub-folders:
    - logo contains CNM and Malaria Consortium logos.
    - gis-data contains a shapefile of the Cambodian provinces.
    - scripts contains several R scripts.
    - pics contains images displayed in the About tab.
    - data contains the 3 data files used in the ODT: Tier_OD.csv, HIS_Data.xlsx and VMW_Data.xlsx.
    - markdown contains the password.md with the text displayed in the Password Tab as well as about.md with the text displayed in the About tab.

<img src="README_pictures/content_folder.png" alt="Drawing" style="width: 200px;"/>
<br>
Figure 1: Content of the ODT folder.

## ODT Content

<img src="README_pictures/screenshot_1.png" alt="Drawing" style="width: 500px;"/>
<br>
Figure 2: Screenshot of the ODT, Province Tabulation.

The ODT is composed of two panels: a left panel used for user input parameters and a main panel which occupy most of the browser window and display graphs and other informations across different tabulations.
Depending on the tabulation selected in the main panel, the left panel content can change and displays different options for selection. For example, when selecting the “Province” tab, one can select a province but not select an OD or a Health Facility.

We describe below the panels (from left to right in the tabulation order): Password, Cambodia, Province, OD, Health Facility, Seasonality, About. One should note that some elements are common to different panels even if the associated data might be different. The ODT is made of four ‘bricks’: (1) alert/outbreak monthly plot extending over the period of available data; (2) Cambodia map colored by provinces; (3) data table with percentage of change and (4) seasonality plots with year by year comparison of monthly morbidity.


### User Input Panel

**DONE: removed reference to a password input panel**

<img src="README_pictures/screenshot_selection.png" alt="Panel" style="width: 200px;"/>
<br>

The left panel can propose different selections, allowing:

 - to select years that will be used as a baseline for the definition of the alert/outbreak threshold. Also these are the years for which data is filtered before being potted in the seasonality tab.
 - through three cascading drop-down lists to select a Province from the list of all provinces, an OD from within the selected province and finally a Health Facility from within the selected OD.
 - the selection of alert/outbreak levels from 3 different choices: ‘High Sensitivity’, ‘Standard’ and ‘Low Sensitivity’.
 - select one or several species between ‘Pf’, ‘Pv’ and ‘Mix’ to allow filtering and analyzing morbidity data for specific malaria species.
 - select ‘HIS’, ‘VMW’ or both to restrict the analysis to patients having being tested in health facilities or by village malaria workers as per the content of the two datasets.
 
 
 ### Alert/Outbreak Monthly Plot
 
 <img src="README_pictures/screenshot_outbreak.png" alt="Outbreak" style="width: 200px;"/>
<br>
 Figure 4: Montly barplot of malaria cases in Kampong Speu province showung an outbreak in April, May and June 2015.
 
 The main purpose of the malaria outbreak detection tool is to detect unusual increases in the number of malaria cases at the Provincial or OD level. This is achieved in 3 phases:
1.	Definition of a 'reference' disease baseline. In the left panel, year or multiple years can be selected to use as baseline, e.g. the numbers of cases for the months of Jan, Feb, ..., Dec during this period are used to define a monthly 'Average Baseline', which is marked by a black dashed line in the graphic. 
2.	Selection of sensitivity warning/alert threshold and creation of warning/alert thresholds for post-baseline data. Using the baseline described above, and pooling all months of data together, the Standard Deviation (SD) of the series is computed. In the left panel, three options offering different levels of sensitivity to define alert/outbreak levels can be used:
a.	"Standard Definition" sets "Baseline + 1 SD" as the alert threshold and "Baseline + 2 SD" as the outbreak threshold. This is the more standard definition.
b.	"High Sensitivity" sets "Baseline + 0.5 SD" as the alert threshold and "Baseline + 1 SD" as the outbreak threshold. These thresholds would typically be used in areas where an increase in the number of malaria cases is considered a great threat.
c.	"Low Sensitivity" sets "Baseline + 2 SD" as the alert threshold and "Baseline + 3 SD" as the outbreak threshold. This option could be used to detect only the most severe outbreaks in reported malaria cases.
3.	Comparison of current surveillance data to warning/alert thresholds to detect when number of cases is above normal. Bars showing the monthly numbers of malaria cases are then coloured based on their relation to the thresholds:
a.	values below the alert threshold are coloured in blue,
b.	values above the alert threshold are flagged and coloured in yellow,
c.	values above the outbreak threshold are flagged and coloured in red.

Discussion: A number of issues concerning how best to construct a 'reference' disease baseline have yet to be fully resolved. For example, what is the minimum number of years of data required to develop a reliable baseline? Should the time period used to estimate baseline lengthen with each year of new data, or should older data be discarded? Should data from known epidemic years be omitted from the baseline calculation? Based on local knowledge, whether some years should be discarded due to exceptional events? Selecting at least the last 2 previous years will offer more robust results.
Discussion is also ongoing about what should be the appropriate warning/alert threshold level. The "Standard definition" may be the default choice, but other choices could be more appropriate depending on the geographical area and the local factors related to transmission, such as the level of artemisnin resistance. For every OD selected, the artemisinin resistance tier is indicated above the Alert/Outbreak detection graph.

### Data Table

The data table provides for a given level (country, province, OD) the recent trends of all levels below (resp. provinces, ODs, Health Facilities). Figures displayed are linked to the right panel and filtered depending on which “species” and “datasets” are selected.
•	First column (Province, OD or Health Facility depending on the Tab): the provinces, ODs, Health Facilities in the selected level,
•	Baseline: same months at the latest quarter in the previous year (see below)
•	Average monthly cases, baseline: average monthly number of cases for the selected species and the selected dataset during the baseline period.
•	Latest quarter: for the selected dataset(s) (HIS, VMW or both HIS and VMW merged), last 3 months for which data is available (e.g. May/Jun/Jul 2015)
•	Average monthly cases, latest quarter: average monthly number of cases for the selected species and the selected dataset during the latest quarter period.
•	Percentage Change in the number of cases from baseline (e.g. May/Jun/Jul 2014) to latest quarter (e.g. May/Jun/Jul 2015). Cell background is green if value is less than 0 (decrease), orange if between 1 and 50% (moderate increase) or red if value is above 50% (large increase).
 
<img src="README_pictures/screenshot_DT.png" alt="Panel" style="width: 500px;"/>

### Cambodia Map

To allow better performance of the tool, the map is **not** linked to which “species” and “datasets” are selected in the right panel.
The map shows the Cambodia provinces colored based on the percentage change between the latest quarter of available data (HIS and VMW dataset merged) compared to the same period in the previous year. Clicking on one province will display the name of the province and the percentage change. Note that the map and data table’ colors will match when the data table is using all data, it is when all 3 species and the two datasets are selected.

<img src="README_pictures/screenshot_map.png" alt="Map" style="width: 500px;"/>
Figure 5: Map of Cambodia colored by the most recent malaria trends.


### Seasonality Plots

<img src="README_pictures/screenshot_seasonality.png" alt="Seasonality" style="width: 500px;"/>
Figure 6: Month by month comparison of Kampong Speu data for 2012, 2013 and 2014.
For the selected species, datasets and years, the sealsonality plot shows a year-by-year comparison of the monthly number of malaria cases in Province, OD or Health Facility.


## Update the ODT


To update the ODT, one can modify three different components: (1) the data; (2) the explanation texts or (3) the internals of the application. When updating the ODT, simply replace the files for the Offline version. For the online version, replace the files and upload the updated app as described below.

### Update Data

To update the data, replace one or several of the three files located in the /Outbreak Detection Tool_2015-12-22/shiny/data folder (Tier_OD.csv, HIS_Data.xlsx and VMW_Data.xlsx.) with new, updated files. Replacing these files, it is essential to keep the same names for the files and use the same data structure, keeping the same column names in the same order as described below. 
Data should be consistent between the two datasets and codes for the same units should be identical across HIS and VMW datasets.

#### HIS Dataset


<img src="README_pictures/screenshot_his.png" alt="Map" style="width: 500px;"/>
Figure 7: Screenshot of the HIS spreadsheet.


**TODO: adapt from the original table format**
Column Name	Description
Code_Prov_T	Code of the province.
Name_Prov_E	Name of the province.
Code_OD_T	Code of the Operational District (OD).
Name_OD_E	Name of the OD.
Code_Facility_T	Code of the Health Facility.
Name_Facility_E	Name of the Health Facility.
Year	Year.
Month	Month.
SumOftreated	Total number of patients treated.
SumOfSevere	Total number of severe malaria cases.
SumOfDeath	Total number of dead patients.
SumOfPf_Slide	Total number of Pf cases detected by microscopy.
SumOfPv_slide	Total number of Pv cases detected by microscopy.
SumOfMix_slide	Total number of Mix Pf/Pv cases detected by microscopy.
SumOfPf_DS	Total number of Pf cases detected by RDT.
SumOfPv_DS	Total number of Pv cases detected by RDT.
SumOfMix_Ds	Total number of Mix Pf/Pv cases detected by RDT.


#### VMW Dataset

<img src="README_pictures/screenshot_vmw.png" alt="VMW" style="width: 500px;"/>
Figure 8: Screenshot of the VMW spreadsheet.

Column Name	Description
Code_Prov_N	Code of the province.
Name_Prov_E	Name of the province.
Code_OD_T	Code of the Operational District (OD).
Name_OD_E	Name of the OD.
Code_Facility_T	Code of the Health Facility.
Name_Facility_E	Name of the Health Facility.
Year	Year.
Month	Month.
Test	Total number of patients tested.
Positive	Total number of patients positive.
Pf	Total number of Pf cases.
Pv	Total number of Pv cases.
Mix	Total number of Mix Pf/Pv cases.

#### Tier OD Dataset

This dataset contains the artemisnin resistance tier status of every OD. This information is displayed in the OD Tab of the ODT (e.g. “Operational District in Tier 3 area: no evidence of artemisinin resistance.”)

<img src="README_pictures/screenshot_tierod.png" alt="Tier OD" style="width: 500px;"/>
Figure 9: Screenshot of teh Tier OD spreadsheet.

Column Name	Description
Tier	Artemisninn Resistance Tier
Code_Prov_T	Code of the province.
Name_Prov_E	Name of the province.
Code_OD_T	Code of the Operational District (OD).
Name_OD_E	Name of the OD.


### Update Text Explanations

To update the text displayed in the Password (resp. About) tabulation, modify the file password.md (resp. readme.md), following the R Markdown syntax described in https://www.rstudio.com/wp-content/uploads/2015/03/rmarkdown-reference.pdf 
We recommend keeping any image added as an illustration to the text in the pics folder.


### Update Applications Internals

Please note that this step requires intermediate to advanced knowledge of both R language and the Shiny framework. It is recommended to backup up all files before proceeding to any modification.
The server.R and ui.R scripts call several scripts located in the scripts folder.  All these scripts can be edited to add functionalities or modify the app. Tutorials on Shiny are accessible at http://shiny.rstudio.com/tutorial/ while a complete reference of all Shiny used functions can be accessed at http://shiny.rstudio.com/reference/shiny/latest/ 


## Deploy Updated ODT

To update the standalone Desktop App (offline), simply replace the server.R, ui.R and content of the www folder in the App folder: /Outbreak Detection Tool_2015-12-22/shiny/.
To deploy the App online or update your existing online App, follow these steps:
•	Install R (https://cran.r-project.org/bin/windows/base/) and RStudio (https://www.rstudio.com/products/rstudio/download/)
•	Open RStudio and install the shiny package (Tools>>Install Packages…) in your RStudio installation.
•	Open the file /Outbreak Detection Tool_2015-12-22/shiny/server.R in RStudio ( File>>Open File…)
o	If needed, create a free account on http://shinyapps.io
o	With your account information, click on Publish Applications… in RStudio and follow the steps.

<img src="README_pictures/screenshot_deploy.png" alt="VMW" style="width: 500px;"/>
Figure 10: Deploy the App online with RStudio.