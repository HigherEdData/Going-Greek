*** do 5003IntactFact
 ** Run interactions using factor variable syntax and imputed data
 ** Interaction effects
 
global log "5003IntactFact"
global logN "5003"
global dsold "2000Impute"

capture log close
clear all
version 13
set matsize 800
set mem 400000k
set linesize 140
set more off
log using "$log", t replace
use "$dsold", clear

*** Models

    local Ys "pellrates nonpellrates pellgap pellratio"
    global Ys "pellrates nonpellrates pellgap pellratio"
    local mYs "pellgap pellratio"
    local Xs "perfrat persoror greekyes"
    global Xs "perfrat persoror greekyes"
    local  Select "  Ndegsel Accept0712 Private"
    global iSelect "i.Ndegsel c.Accept0712 Private"
    local mSelect  "m.Ndegsel Accept0712 Private"
    local   Controls "pellper0712 np_linc0813K Nmininst perWomen perBlkHis perSTEM lnendow0712K schsize0712K   urbanicity4   Region"
    global iControls "pellper0712 np_linc0813K Nmininst perWomen perBlkHis perSTEM c.lnendow0712K schsize0712K i.urbanicity4 i.Region"

*** MI Setup

    mi import ice, automatic
    mi unregister Findnotes Anotes Qnotes Samplenotes pellrates nonpellrates pellgap pellratio pellcomp nonpellcomp

    mi describe 
    mi convert wide, clear

    mi xeq 1: sum `Ys' `Xs'  `Select' `Controls' if ccvar==1, sep(0)

    sum $Ys $Xs _1_persoror _1_perGreek _1_greekyes if ccvar==1
 
 ** Drop (234207) Washington and Lee University for wrong reporting of perfrat & persoror

    drop if unitid==234207
    sum $Ys $Xs _1_persoror _1_perGreek _1_greekyes if ccvar==1

*** Interactions using factor variable syntax

**1 % Greek and Greek house

    global X "perfrat"

 ** Table 03: Gap = (Non-Pell rates - Pell rates)

    global title "Table 03: Gap = (Non-Pell rates - Pell rates)"
    global Y "pellgap"

    qui mi estimate, ni(20) dots post: regress $Y c.$X
    estimates store M1

    qui mi estimate, ni(20) dots post: regress $Y      i.greekyes
    estimates store M2

    qui mi estimate, ni(20) dots post: regress $Y c.$X i.greekyes
    estimates store M3

    qui mi estimate, ni(20) dots post: regress $Y c.$X#ibn.greekyes
    estimates store M4

    qui mi estimate, ni(20) dots post: regress $Y c.$X#ibn.greekyes $iSelect
    estimates store M5

    qui mi estimate, ni(20) dots post: regress $Y c.$X#ibn.greekyes $iSelect $iControls
    estimates store M6

    estimates table M1 M2 M3 M4 M5 M6, b(%9.3f) star(.001 .01 .05) stats(N F_mi p_mi) title($title)


 ** Table 04: non-Pell graduation rates

    global title "Table 04: non-Pell graduation rates"
    global Y "nonpellrates"

    qui mi estimate, ni(20) dots post: regress $Y c.$X
    estimates store M1

    qui mi estimate, ni(20) dots post: regress $Y      i.greekyes
    estimates store M2

    qui mi estimate, ni(20) dots post: regress $Y c.$X i.greekyes
    estimates store M3

    qui mi estimate, ni(20) dots post: regress $Y c.$X#ibn.greekyes
    estimates store M4

    qui mi estimate, ni(20) dots post: regress $Y c.$X#ibn.greekyes $iSelect
    estimates store M5

    qui mi estimate, ni(20) dots post: regress $Y c.$X#ibn.greekyes $iSelect $iControls
    estimates store M6

    estimates table M1 M2 M3 M4 M5 M6, b(%9.3f) star(.001 .01 .05) stats(N F_mi p_mi) title($title)

 ** Table 05: Pell graduation rates

    global title "Table 05: Pell graduation rates"
    global Y "pellrates"

    qui mi estimate, ni(20) dots post: regress $Y c.$X
    estimates store M1

    qui mi estimate, ni(20) dots post: regress $Y      i.greekyes
    estimates store M2

    qui mi estimate, ni(20) dots post: regress $Y c.$X i.greekyes
    estimates store M3

    qui mi estimate, ni(20) dots post: regress $Y c.$X#ibn.greekyes
    estimates store M4

    qui mi estimate, ni(20) dots post: regress $Y c.$X#ibn.greekyes $iSelect
    estimates store M5

    qui mi estimate, ni(20) dots post: regress $Y c.$X#ibn.greekyes $iSelect $iControls
    estimates store M6

    estimates table M1 M2 M3 M4 M5 M6, b(%9.3f) star(.001 .01 .05) stats(N F_mi p_mi) title($title)

log close

 