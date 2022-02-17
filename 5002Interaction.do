*** do 5002Interaction
 ** Check extreme cases
 ** Interaction effects
 
global log "5002Interaction"
global logN "5002"
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

*** Check 82% in perfrat, persoror, & greekyes

    sort perfrat
    sum perfrat persoror greekyes schsize0712K
    graph twoway ///
        (scatter perfrat persoror, msym(oh) ylab(-20(20)80, grid glcolor(gs14)) msiz(*1.1))
    graph export Greekpercent.wmf, replace
    
    format schsize0712K pellrates nonpellrates %9.4g
    list unitid instnm perfrat persoror greekyes schsize0712K pellrates nonpellrates if perfrat>=60, clean noob
    list unitid instnm perfrat persoror greekyes schsize0712K pellrates nonpellrates if perfrat<0, clean noob
    note Anotes: (234207) Washington and Lee University has 82% for both /// 
         perfrat and persoror. This could be a wrong reporting and should be /// 
         removed from analyses. Other than this, the values look reasonable. 

*** With and without (234207) Washington and Lee University from analysis

    global X "perfrat"

 ** Table 03: Gap = (Non-Pell rates - Pell rates)

    global Y "pellgap"
    qui regress $Y $X $iSelect $iControls
    estimates store Yes  

    qui regress $Y $X $iSelect $iControls if unitid~=234207
    estimates store No

    estimates table Yes No, b(%9.3f) star(.001 .01 .05) stats(N r2) title($Y)

 ** Table 04: non-Pell graduation rates

    global Y "nonpellrates"
    qui regress $Y $X $iSelect $iControls
    estimates store Yes  

    qui regress $Y $X $iSelect $iControls if unitid~=234207
    estimates store No

    estimates table Yes No, b(%9.3f) star(.001 .01 .05) stats(N r2) title($Y)

 ** Table 05: Pell graduation rates

    global Y "pellrates"
    qui regress $Y $X $iSelect $iControls
    estimates store Yes  

    qui regress $Y $X $iSelect $iControls if unitid~=234207
    estimates store No

    estimates table Yes No, b(%9.3f) star(.001 .01 .05) stats(N r2) title($Y)

*** Check 0% & 100% in graduation rates

    sort pellrates nonpellrates
    sum pellrates nonpellrates
    graph twoway ///
        (scatter pellrates nonpellrates, msym(oh) ylab(0(20)100, grid glcolor(gs14)) msiz(*1.1))
    graph export Graduaterate.wmf, replace

    list unitid instnm pellrates nonpellrates schsize0712K Private pellper0712 Nmininst urbanicity4 if pellrates>=98 | nonpellrates>=98, clean noob
    nmlab pellper0712 Nmininst schsize0712K urbanicity4

    list unitid instnm pellrates nonpellrates schsize0712K Private pellper0712 Nmininst urbanicity4 if pellrates<=0 | nonpellrates<=0, clean noob

*** Interactions

**1 % Greek and Greek house
 
    sum perfrat persoror greekyes
    corr perfrat persoror greekyes

    graph twoway ///
        (scatter pellrates nonpellrates if greekyes==0, msym(oh) ylab(0(20)100, grid glcolor(gs14)) msiz(*1.1) /// 
        title("1. No Greek House", size(medium) pos(11)) name(temp1, replace))
        
    graph twoway ///
        (scatter pellrates nonpellrates if greekyes==1, msym(oh) ylab(0(20)100, grid glcolor(gs14)) msiz(*1.1) /// 
        title("2. Greek House", size(medium) pos(11)) name(temp2, replace))

    gr combine temp1 temp2, scheme(s1mono) /// 
        col(2) xsize(14) ysize(9) iscale(*.8) imargin(medsmall) graphregion(margin(l=5 r=5)) 
    graph export Greekhouse.wmf, replace

 ** Table 03: Gap = (Non-Pell rates - Pell rates)

    global Y "pellgap"

    qui regress $Y c.$X
    estimates store M1

    qui regress $Y      i.greekyes
    estimates store M2

    qui regress $Y c.$X i.greekyes
    estimates store M3

    qui regress $Y c.$X#ibn.greekyes
    estimates store M4

    qui regress $Y c.$X#ibn.greekyes $iSelect
    estimates store M5

    qui regress $Y c.$X#ibn.greekyes $iSelect $iControls
    estimates store M6

    estimates table M1 M2 M3 M4 M5 M6, b(%9.3f) star(.001 .01 .05) stats(N r2) title($Y)

 ** Table 04: non-Pell graduation rates

    global Y "nonpellrates"

    qui regress $Y c.$X
    estimates store M1

    qui regress $Y      i.greekyes
    estimates store M2

    qui regress $Y c.$X i.greekyes
    estimates store M3

    qui regress $Y c.$X#ibn.greekyes
    estimates store M4

    qui regress $Y c.$X#ibn.greekyes $iSelect
    estimates store M5

    qui regress $Y c.$X#ibn.greekyes $iSelect $iControls
    estimates store M6

    estimates table M1 M2 M3 M4 M5 M6, b(%9.3f) star(.001 .01 .05) stats(N r2) title($Y)

 ** Table 05: Pell graduation rates

    global Y "pellrates"

    qui regress $Y c.$X
    estimates store M1

    qui regress $Y      i.greekyes
    estimates store M2

    qui regress $Y c.$X i.greekyes
    estimates store M3

    qui regress $Y c.$X#ibn.greekyes
    estimates store M4

    qui regress $Y c.$X#ibn.greekyes $iSelect
    estimates store M5

    qui regress $Y c.$X#ibn.greekyes $iSelect $iControls
    estimates store M6

    estimates table M1 M2 M3 M4 M5 M6, b(%9.3f) star(.001 .01 .05) stats(N r2) title($Y)

**2 % Greek and acceptance rates

    global iSelect "i.Ndegsel Private"
    global iControls "pellper0712 np_linc0813K Nmininst perWomen perBlkHis perSTEM c.lnendow0712K schsize0712K i.urbanicity4 i.Region"
 
 ** Table 03: Gap = (Non-Pell rates - Pell rates)

    global Y "pellgap"
    qui regress $Y c.$X c.Accept0712 
    estimates store M1

    qui regress $Y c.$X##c.Accept0712 
    estimates store M2
    
    qui regress $Y c.$X##c.Accept0712 $iSelect 
    estimates store M3

    qui regress $Y c.$X##c.Accept0712 $iSelect $iControls
    estimates store M4

    estimates table M1 M2 M3 M4, b(%9.3f) star(.001 .01 .05) stats(N r2) title($Y; % Greek and Acceptance rates)

 ** Table 04: non-Pell graduation rates

    global Y "nonpellrates"
    qui regress $Y c.$X c.Accept0712 
    estimates store M1

    qui regress $Y c.$X##c.Accept0712 
    estimates store M2
    
    qui regress $Y c.$X##c.Accept0712 $iSelect 
    estimates store M3

    qui regress $Y c.$X##c.Accept0712 $iSelect $iControls
    estimates store M4

    estimates table M1 M2 M3 M4, b(%9.3f) star(.001 .01 .05) stats(N r2) title($Y; % Greek and Acceptance rates)

 ** Table 05: Pell graduation rates

    global Y "pellrates"
    qui regress $Y c.$X c.Accept0712 
    estimates store M1

    qui regress $Y c.$X##c.Accept0712 
    estimates store M2
    
    qui regress $Y c.$X##c.Accept0712 $iSelect 
    estimates store M3

    qui regress $Y c.$X##c.Accept0712 $iSelect $iControls
    estimates store M4

    estimates table M1 M2 M3 M4, b(%9.3f) star(.001 .01 .05) stats(N r2) title($Y; % Greek and Acceptance rates)

**3 % Greek and endowment

    global iSelect "i.Ndegsel c.Accept0712 Private"
    global iControls "pellper0712 np_linc0813K Nmininst perWomen perBlkHis perSTEM schsize0712K i.urbanicity4 i.Region"

 ** Table 03: Gap = (Non-Pell rates - Pell rates)

    global Y "pellgap"
    qui regress $Y c.$X c.lnendow0712K 
    estimates store M1

    qui regress $Y c.$X##c.lnendow0712K 
    estimates store M2
    
    qui regress $Y c.$X##c.lnendow0712K $iSelect 
    estimates store M3

    qui regress $Y c.$X##c.lnendow0712K $iSelect $iControls
    estimates store M4

    estimates table M1 M2 M3 M4, b(%9.3f) star(.001 .01 .05) stats(N r2) title($Y; % Greek and endowment)

 ** Table 04: non-Pell graduation rates

    global Y "nonpellrates"
    qui regress $Y c.$X c.lnendow0712K 
    estimates store M1

    qui regress $Y c.$X##c.lnendow0712K 
    estimates store M2
    
    qui regress $Y c.$X##c.lnendow0712K $iSelect 
    estimates store M3

    qui regress $Y c.$X##c.lnendow0712K $iSelect $iControls
    estimates store M4

    estimates table M1 M2 M3 M4, b(%9.3f) star(.001 .01 .05) stats(N r2) title($Y; % Greek and endowment)

 ** Table 05: Pell graduation rates

    global Y "pellrates"
    qui regress $Y c.$X c.lnendow0712K 
    estimates store M1

    qui regress $Y c.$X##c.lnendow0712K 
    estimates store M2
    
    qui regress $Y c.$X##c.lnendow0712K $iSelect 
    estimates store M3

    qui regress $Y c.$X##c.lnendow0712K $iSelect $iControls
    estimates store M4

    estimates table M1 M2 M3 M4, b(%9.3f) star(.001 .01 .05) stats(N r2) title($Y; % Greek and endowment)

**4 % Greek and selectivity

    tab Ndegsel, m
    global iControls "c.Accept0712 Private pellper0712 np_linc0813K Nmininst perWomen perBlkHis perSTEM c.lnendow0712K schsize0712K i.urbanicity4 i.Region"

 ** Table 03: Gap = (Non-Pell rates - Pell rates)

    global Y "pellgap"

    qui regress $Y c.$X
    estimates store M1

    qui regress $Y c.$X i.Ndegsel
    estimates store M2

    qui regress $Y c.$X#ibn.Ndegsel
    estimates store M3

    qui regress $Y c.$X#ibn.Ndegsel $iControls
    estimates store M4

    estimates table M1 M2 M3 M4, b(%9.3f) star(.001 .01 .05) stats(N r2) title(Gap = (Non-Pell rates - Pell rates))

 ** Table 04: non-Pell graduation rates

    global Y "nonpellrates"

    qui regress $Y c.$X
    estimates store M1

    qui regress $Y c.$X i.Ndegsel
    estimates store M2

    qui regress $Y c.$X#ibn.Ndegsel
    estimates store M3

    qui regress $Y c.$X#ibn.Ndegsel $iControls
    estimates store M4

    estimates table M1 M2 M3 M4, b(%9.3f) star(.001 .01 .05) stats(N r2) title(non-Pell graduation rates)

 ** Table 05: Pell graduation rates

    global Y "pellrates"
    
    qui regress $Y c.$X
    estimates store M1

    qui regress $Y c.$X i.Ndegsel
    estimates store M2

    qui regress $Y c.$X#ibn.Ndegsel
    estimates store M3

    qui regress $Y c.$X#ibn.Ndegsel $iControls
    estimates store M4

    estimates table M1 M2 M3 M4, b(%9.3f) star(.001 .01 .05) stats(N r2) title(Pell graduation rates)

log close

 