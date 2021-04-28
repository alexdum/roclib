---
editor_options: 
  markdown: 
    wrap: 72
---

## Dashboard to present climate change aspects in Romania

Built in [R](https://www.r-project.org/) using
[Shiny](https://shiny.rstudio.com/), this dashboard aims to provide
accurate and relevant facts and statistics about climate change in
Romania.

The dashboard is structured in two main sections:

-   [Key figures and *Graphs*](#Graphs)
-   [Relevant *Maps*](#maps)

### Tools

-   Visualisation: [shiny](https://shiny.rstudio.com/)
-   Map: [leaflet](https://rstudio.github.io/leaflet/)
-   NetCDF manipulating:
    [ncdf4](https://cran.r-project.org/web/packages/ncdf4/index.html)
-   Chart: [dygraphs](https://rstudio.github.io/dygraphs/);
    [plotly](https://plot.ly/r/)
-   Table: [DT](https://rstudio.github.io/DT/)
-   Deployment: [via Drupal shinyapps.io](https://www.drupal.org/)

### RoCliB

The Dashboard is based on the adjusted RCMs data, which are provided via
the Zenodo open-access repository, which allows the uploading of files
up to 50 GB. The data are provided in a netCDF CF-1.4-compliant format
using netCDF4 compression. For each variable and scenario distinct files
were created: 4 climate variables × (10 Historical + 10 RCP8.5 + 10
RCP4.5) = 120 netCDF files. The terms of use for the bias-corrected data
are the same as those from the original EURO-CORDEX simulations obtained
from ESGF servers .

\
The main characteristics of the RoCliB dataset are listed below:

-   Climate variables: air temperature (tasAdjust - Celsius degree),
    maximum air temperature (tasmaxAdjust - Celsius degree), minimum air
    temperature (tasminAdjust - Celsius degree) and precipitation
    (prAdjust - millimeters);

-   Temporal resolution: daily;

-   Temporal extent:

    -   Historical: 1971-2005;

    -   RCP4.5 and RCP8.5: 2006-2100;

-   Spatial resolution: 0.1 degrees (\~10km);

-   Spatial extent: from 20.1 to 29.8°E and 43.5 to 48.4°N;

-   File format: netCDF, CF-1.4-compliant format using netCDF4 compression; 

-  Coordinate system: WGS 1984 (EPSG:4326); 
-  Naming convention: variablename_ROU-11_cmip5experiment_globalmodel_run_regionalmodel_rcmversionid_timefrequency_starttime-endtime.nc;
- Data repository: <https://doi.org/10.5281/zenodo.4642464>.

### Source code

Repository:
[https://github.com/alexdum](https://github.com/alexdum/roclib)\
Report issue(s) or feature(s) request
[here](https://github.com/alexdum/roclib/issues)

### Developer

Alexandru Dumitrescu <br/> Email:
[dumitrescu\@meteoromania.ro](mailto:dumitrescu@meteoromania.ro)
<br/><br/> Vlad Amihaesei <br/> Email:
[vlad.amihaesei\@meteoromania.ro](mailto:vlad.amihaesei@meteoromania.r)

------------------------------------------------------------------------

(c) 2021 Alexandru Dumitrescu \| [MIT
    License](https://github.com/alexdum/roclib/blob/master/LICENSE)
