*** do 2140Table0345
 ** v01: Table 3 4 5
 
global path "FirstGen/07_160314"
global log "2140Table0345"
global logN "2140"
global dsold "2000Impute"
global tag "$path" 
global graf ".emf"

capture log close
clear all
version 13
set matsize 800
set mem 400000k
set linesize 140
set more off
log using "$log", t replace

*** Models

    local Y "pellgap nonpellrates pellrates"
    local X "perGreek greekyes"
    local  Select "  Ndegsel Accept0712 Private"
    global iSelect "i.Ndegsel Accept0712 Private"
    local mSelect "m.Ndegsel Accept0712 Private"
    local   Controls "pellper0712 Nmininst perSTEM lnendow0712K schsize0712K   urbanicity4   Region np_linc0813K perWomen perBlkHis"
    global iControls "pellper0712 Nmininst perSTEM lnendow0712K schsize0712K i.urbanicity4 i.Region np_linc0813K perWomen perBlkHis"

*** MI Setup

    use "$dsold", clear
    mi import ice, automatic
    mi unregister Findnotes Anotes Qnotes Samplenotes pellrates nonpellrates pellgap pellratio pellcomp nonpellcomp

    mi describe 
    mi convert wide, clear

    nmlab `Y' `Xs' `Select' `Controls', col(21)

    global X1 "perGreek"
    global X2 "greekyes"

    mi xeq 1: sum `Y' `X' `Select' `Controls' if ccvar==1, sep(0)

*** Table 03: Gap = (Non-Pell rates - Pell rates)

    global Y "pellgap"
    global title "*** Table 3: Regression Analyses for Gap = (Non-Pell rates - Pell rates)"
    sum $Y if ccvar==1

    do 2800Model

*** Table 04: Non-Pell rates

    global Y "nonpellrates"
    global title "*** Table 4: Regression Analyses for Non-Pell Graduation Rates"
    sum $Y if ccvar==1

    do 2800Model

*** Table 05: Pell rates

    global Y "pellrates"
    global title "*** Table 5: Regression Analyses for Pell Graduation Rates"
    sum $Y if ccvar==1

    do 2800Model

*** Standardized coefficients

    mi extract 1

 ** Table 03: Gap = (Non-Pell rates - Pell rates)

    global Y "pellgap"
    qui regress $Y c.$X1 $iSelect $iControls
    listcoef

    qui regress $Y i.$X2 $iSelect $iControls
    listcoef

 ** Table 04: Non-Pell rates

    global Y "nonpellrates"
    qui regress $Y c.$X1 $iSelect $iControls
    listcoef

    qui regress $Y i.$X2 $iSelect $iControls
    listcoef

 ** Table 05: Pell rates

    global Y "pellrates"
    qui regress $Y c.$X1 $iSelect $iControls
    listcoef

    qui regress $Y i.$X2 $iSelect $iControls
    listcoef

log close

