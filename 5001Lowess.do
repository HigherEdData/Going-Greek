*** do 5001Lowess
 ** lowess of graduation rates on % of students in Greek houses
 
global log "5001Lowess"
global logN "5001"
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
    global iSelect "i.Ndegsel Accept0712 Private"
//    global iSelect "i.Ndegsel Accept0712"
    local mSelect "m.Ndegsel Accept0712 Private"
    local  Controls "pellper0712 np_linc0813K Nmininst perWomen perBlkHis perSTEM lnendow0712K schsize0712K   urbanicity4   Region"
    global iControls "pellper0712 np_linc0813K Nmininst perWomen perBlkHis perSTEM lnendow0712K schsize0712K i.urbanicity4 i.Region"
//    global iControls "pellper0712 np_linc0813K          perWomen perBlkHis perSTEM lnendow0712K              i.urbanicity4 i.Region"
//    local  Controls  "pellper0712 np_linc0813K          perWomen perBlkHis perSTEM lnendow0712K                urbanicity4   Region"

*** High propensity of Greek school

    global Y "perfrat"
    sort $Y
    tab $Y
    gen perfrat75 = $Y>11
    tab $Y perfrat75, m
    regress perfrat $iSelect $iControls
    predict predv
    
    sort predv
    tab predv
    list unitid predv perfrat if predv>14.5, clean noob
    tab perfrat if predv>14.5
    count if predv>14.5

    gen LargeG = .
    replace LargeG=0 if predv>16 & perfrat<=0
    replace LargeG=1 if predv>16 & perfrat>=15

    foreach var of varlist pellrates nonpellrates pellgap {
        ttest `var' if LargeG<., by(LargeG)
    }

*** Standardized coefficients for Model 3

    global X "perfrat"

 ** Table 03: Gap = (Non-Pell rates - Pell rates)

    global Y "pellgap"
    qui regress $Y $X $iSelect $iControls
    listcoef

 ** Table 04: non-Pell graduation rates

    global Y "nonpellrates"
    qui regress $Y $X $iSelect $iControls
    listcoef

*** Table 05: Pell graduation rates

    global Y "pellrates"
    qui regress $Y $X $iSelect $iControls
    listcoef

*** Graph 

    sort perfrat
    global gnm lowess-perfrat

*** lowess plots

 ** non-Pell graduation rates

    global Y "nonpellrates"

    lowess $Y perfrat if perfrat>=0, jitter(1) generate(l$Y) xlab(0(10)80) bwidth(.5) ///
        ytitle("Graduation rates (%)", margin(medsmall)) ylab(0(10)100) ///
        scheme(s1mono) title("1. None-Pell Graduation Rates", size(medium) pos(11)) ///
        xtitle("Percent of Men in Fraternities", size(medsmall) margin(medsmall)) name(SF1, replace)
    label var l$Y "None-Pell"
    
 ** Pell graduation rates

    global Y "pellrates"

    lowess $Y perfrat if perfrat>=0, jitter(1) generate(l$Y) xlab(0(10)80) bwidth(.5) ///
        ytitle("Graduation rates (%)", margin(medsmall)) ylab(0(10)100) ///
        scheme(s1mono) title("2. Pell Graduation Rates", size(medium) pos(11)) ///
        xtitle("Percent of Men in Fraternities", size(medsmall) margin(medsmall)) name(SF2, replace)
    label var l$Y "Pell"

 ** Gap = (Non-Pell rates - Pell rates)

    global Y "pellgap"

    lowess $Y perfrat if perfrat>=0, jitter(1) generate(l$Y) xlab(0(10)80) bwidth(.5) ///
        ytitle("Graduation rates (%)", margin(medsmall)) ylab(-60(20)60) ///
        scheme(s1mono) title("3. Non-Pell - Pell", size(medium) pos(11)) ///
        xtitle("Percent of Men in Fraternities", size(medsmall) margin(medsmall)) name(SF3, replace)
    label var l$Y "Differences"

 ** All lowess lines without observed data
 
    graph twoway ///
        (scatter lnonpellrates perfrat if perfrat>=0, c(l) yaxis(1) msym(i) ylab(0(20)100, grid glcolor(gs14)) ytitle("Graduation rates (%)", margin(medsmall)) msiz(*1.1) lcol(blue) lpat(shortdash_dot)) ///
        (scatter lpellrates perfrat if perfrat>=0, c(l) yaxis(1) msym(i) msiz(*1.1) lcol(blue) lpat(dash)) ///
        (scatter lpellgap perfrat if perfrat>=0, c(l) yaxis(2) msym(i) ytitle("Differences (%)", margin(medsmall) axis(2)) msiz(*1.1) lcol(red) lpat(solid)), ///
        scheme(s1mono) title("4. All Lowess Lines", size(medium) pos(11)) ///
        xtitle("Percent of Men in Fraternities", size(small) margin(medsmall)) ///
        legend(cols(1) region(lstyle(none)) ring(0) pos(5)) name(SF4, replace)

    gr combine SF1 SF2 SF3 SF4, scheme(s1mono) /// 
        col(2) xsize(16) ysize(16) iscale(*.8) imargin(medsmall) graphregion(margin(l=5 r=5)) 
    graph export lowess.wmf, replace
/*
    graph export lowess.eps, replace
    graph export lowess.emf, replace
    graph export lowess.png, replace
*/
log close

