# TB Mapper

A web app to load data from http://www.who.int/tb/country/data/download/ and display it on maps, more or less following WHO's [Standard Operating Procedures for WHO maps](http://gamapserver.who.int/gho/gis/training/DMF_GIS2010_2_SOPSforWHOMaps.pdf). 


## Requirements

Rstudio with `shiny`, `dplyr` packages installed.


## Use

A quick way of running this code directly from RStudio is to do:
```
> library(shiny)
> runGitHub("tb_mapper", "hazimtimimi") 
```

## About the maps

These are generated using shape files approved by WHO in July 2011. The files have been transformed into the following data frames:

* gworld
* gpoly
* gline
* centres
* pieces

These are the same shape files used in [`whomap`](https://github.com/glaziou/whomap) and [`global_report`](https://github.com/hazimtimimi/global_report)

## Acknowledgments

This is built on original work from [Tom Hiatt](https://github.com/tomhiatt) and [Philippe Glaziou](https://github.com/glaziou), and was inspired by ideas from Jonathan Polansky.
