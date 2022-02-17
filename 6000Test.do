*** do 6000Test
 ** Interaction effects
 
global log "6000Test"
global logN "6000"
global dsold "4000Extract"
global graf ".emf"

capture log close
clear all
version 13
set matsize 800
set mem 400000k
set linesize 140
set more off
use "$dsold", clear
log using "$log", t replace

*** Models

    local Ys "pellrates nonpellrates pellgap pellratio"
    local mYs "pellgap pellratio"
    local Xs "perfrat persoror greekyes"
    local  Select "  Ndegsel Accept0712 Private"
    global iSelect "i.Ndegsel c.Accept0712 Private"
    local mSelect  "m.Ndegsel Accept0712 Private"
    local   Controls "pellper0712 np_linc0813K Nmininst perWomen perBlkHis perSTEM lnendow0712K schsize0712K   urbanicity4   Region"
    global iControls "pellper0712 np_linc0813K Nmininst perWomen perBlkHis perSTEM c.lnendow0712K schsize0712K i.urbanicity4 i.Region"

    global X "perfrat"

 ** Table 03: Gap = (Non-Pell rates - Pell rates)

    global Y "greekyes"
    tab $Y, m

    logit $Y c.perfrat $iSelect 
    test c.perfrat

    logit $Y c.perfrat##c.perfrat $iSelect 
    logit, coeflegend
    estimate store full
    
    test c.perfrat
    tes c.perfrat c.perfrat#c.perfrat

    logit $Y $iSelect 
    estimate store noperfrat

    lrtest full noperfrat
    
log close

 