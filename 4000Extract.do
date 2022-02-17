*** do 4000Extract
 ** v01: Extract imputed data (m=1) for multilevel analysis
 
global log "4000Extract"
global dsold "2000Impute"
global dsnew "4000Extract"

capture log close
clear all
version 13
set matsize 800
set mem 400000k
set linesize 140
set more off
log using "$log", t replace
use "$dsold", clear

*** MI Setup

    mi import ice, automatic
    mi unregister Findnotes Anotes Qnotes Samplenotes pellrates nonpellrates pellgap pellratio pellcomp nonpellcomp

    mi describe 

    mi extract 1
    nmlab `Ys' `Xs' `Select' `Controls', col(21)
    sum `Ys' `Xs' `Select' `Controls' if ccvar==1, sep(0)

*** Model

    local Xs "perfrat persoror greekyes"
    local  Select "  Ndegsel Accept0712 Private"

    global Y "pellgap"
    global X "perfrat"
    global iSelect "i.Ndegsel Accept0712 Private"
    global  Select "Ndegsel Accept0712 Private"
    global iControls "pellper0712 np_linc0813K Nmininst perSTEM lnendow0712K schsize0712K i.urbanicity4 i.Region"
    global iControls "pellper0712 np_linc0813K Nmininst perWomen perBlkHis perSTEM lnendow0712K schsize0712K i.urbanicity4 i.Region"
    global  Controls "pellper0712 np_linc0813K Nmininst perWomen perBlkHis perSTEM lnendow0712K schsize0712K urbanicity4 Region"

    keep if ccvar==1

    keep unitid instnm Findnotes Anotes Qnotes Samplenotes pellrates nonpellrates ///
         pellgap pellratio perfrat persoror perGreek greekyes $Select $Controls

    order unitid instnm Findnotes Anotes Qnotes Samplenotes pellrates nonpellrates ///
         pellgap pellratio perfrat persoror perGreek greekyes $Select $Controls

    sum $Y $X $iSelect $iControls, sep(0)

*** Table 03, Model 3: Gap = (Non-Pell rates - Pell rates)

    regress $Y $X $iSelect $iControls
    sum, sep(0)

*** Save data 

    save "$dsnew", replace

log close

