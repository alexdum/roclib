---
editor_options: 
  markdown: 
    wrap: 72
---

##### Dashboard to present climate change aspects in Romania

Built in [R](https://www.r-project.org/?target=_blank) using
[Shiny](https://shiny.rstudio.com/?target=_blank), this dashboard aims to provide
accurate and relevant facts and statistics about climate change in
Romania. The application is based on ensemble means computed from 10
adjusted RCMs data, which are provided via the Zenodo open-access
repository (RoCliB). The data are archived in a netCDF CF-1.4-compliant
format using netCDF4 compression. For each variable and scenario
distinct files were created: 4 climate variables × (10 Historical + 10
RCP8.5 + 10 RCP4.5) = 120 netCDF files. The terms of use for the
bias-corrected data are the same as those from the original EURO-CORDEX
simulations obtained from ESGF servers .

##### The main characteristics of the RoCliB dataset are listed below:

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

-   File format: netCDF, CF-1.4-compliant format using netCDF4
    compression;

-   Coordinate system: WGS 1984 (EPSG:4326);

-   Naming convention:
    variablename_ROU-11_cmip5experiment_globalmodel_run_ regionalmodel_rcmversionid _timefrequency_starttime-endtime.nc;

-   Data source:
    [https://doi.org/10.5281/zenodo.4642464](https://doi.org/10.5281/zenodo.4642464?target=_blank)

##### The dashboard is structured in two main sections:

-   [Key figures and *Graphs*](#Graphs)
-   [Relevant *Maps*](#maps)

##### Tools

-   Visualisation: [shiny](https://shiny.rstudio.com/?target=_parent)
-   Map: [leaflet](https://rstudio.github.io/leaflet/?target=_blank)
-   NetCDF manipulating:
    [ncdf4](https://cran.r-project.org/web/packages/ncdf4/index.html?target=_blank)
-   Chart: [plotly](https://plot.ly/r/?target=_blank)
-   Table: [DT](https://rstudio.github.io/DT/?target=_blank)

##### Source code

Repository:
[https://github.com/alexdum](https://github.com/alexdum/roclib?target=_blank)

Report issue(s) or feature(s) request
[here](https://github.com/alexdum/roclib/issues?target=_blank)

##### Developer

Alexandru Dumitrescu:
[dumitrescu@meteoromania.ro](mailto:dumitrescu@meteoromania.ro)

Vlad Amihaesei:
[vlad.amihaesei@meteoromania.ro](mailto:vlad.amihaesei@meteoromania.r)

------------------------------------------------------------------------

(c) 2021 SUSCAP MeteoRomania \| [MIT
    License](https://github.com/alexdum/roclib/blob/master/LICENSE)
