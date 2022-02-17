*** do 2100Table01
 ** v01: Table 1 Descriptive statistics 
  * Use imputed data for means; use un-imputed values for minimum amd maximum
 ** v02, adjust model specification
 
global path "FirstGen/07_160314"
global log "2100Table01"
global logN "2100"
global dsold1 "1000cln"
global dsold2 "2000Impute"
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

    local Ys "pellgap nonpellrates pellrates pellratio"
    local mYs "pellgap pellratio"
    local Xs "perGreek greekyes perfrat persoror"
    local  Select "  Ndegsel Accept0712 Private"
    local iSelect "i.Ndegsel Accept0712 Private"
    local mSelect "m.Ndegsel Accept0712 Private"
    local  Controls "pellper0712 np_linc0813K Nmininst perWomen perBlkHis perSTEM lnendow0712K schsize0712K   urbanicity4   Region"
    local iControls "pellper0712 np_linc0813K Nmininst perWomen perBlkHis perSTEM lnendow0712K schsize0712K i.urbanicity4 i.Region"

*** Descriptive analyses: imputed data

    use "$dsold2", clear
    mi import ice, automatic
    mi unregister Findnotes Anotes Qnotes Samplenotes pellrates nonpellrates pellgap pellratio pellcomp nonpellcomp

    mi describe 
    sort unitid
    // list unitid perfrat persoror greekyes if ccvar==1 & (perfrat<0 | persoror<0), clean noobs
    ** 85 cases have negative imputed values for % frat & soro

    mi convert wide, clear
    mi unset, asis

    local Controls "pellper0712 np_linc0813K Nmininst perWomen perBlkHis perSTEM lnendow0712K schsize0712K urbanicity4 Region"
    local Select "Ndegsel avgSAT0713 Accept0712 Private"
    nmlab `Ys' `Xs' `Select' `Controls', col(21)

    sum pellrates if ccvar==1

    local iSelect "ibn.Ndegsel Accept0712 Private"
    local iControls "pellper0712 np_linc0813K Nmininst perWomen perBlkHis perSTEM lnendow0712K schsize0712K ibn.urbanicity4 ibn.Region"

    sum `Ys' `Xs' `iSelect' `iControls' if ccvar==1 //
    table Ndegsel, contents(mean perGreek n perGreek ) format(%8.2f) row

    local iSelect "i.Ndegsel avgSAT0713 Accept0712 Private"
    local iControls "pellper0712 np_linc0813K Nmininst perSTEM lnendow0712K schsize0712K i.urbanicity4 i.Region"

    foreach nam in pellgap nonpellrates pellrates pellratio perGreek greekyes perfrat persoror {
        qui sum `nam' if ccvar==1
        local N = r(N)
        local mean = r(mean)
            local m0 = `mean'
        local sd = r(sd)
            local sd0 = `sd'
        local min = r(min)
        local max = r(max)
        if `N' == 1082 {
            di %12s "`nam'" _col(14) "|" _col(19) %6.0f `N' _col(27) %10.5f `mean' _col(39) %10.5f `sd'  _col(73) %10.5f `min'  _col(84) %10.5f `max'  
        } 
        else {
            local i = 1
            while `i' <= 20 {
                qui sum _`i'_`nam' if ccvar==1
                local m`i' = r(mean)
                local s`i' = r(sd)
                local i = `i' + 1
            }
            local mean = (`m1'+`m2'+`m3'+`m4'+`m5'+`m6'+`m7'+`m8'+`m9'+`m10'+`m11'+`m12'+`m13'+`m14'+`m15'+`m16'+`m17'+`m18'+`m19'+`m20')/20
            local sd = (`s1'+`s2'+`s3'+`s4'+`s5'+`s6'+`s7'+`s8'+`s9'+`s10'+`s11'+`s12'+`s13'+`s14'+`s15'+`s16'+`s17'+`s18'+`s19'+`s20')/20
            di %12s "`nam'" _col(14) "|" _col(19) %6.0f `N' _col(27) %10.5f `mean' _col(39) %10.5f `sd' _col(50) %10.5f `m0'  _col(62) %10.5f `sd0' _col(73) %10.5f `min'  _col(84) %10.5f `max'  
            // if N !=1082, show original mean and sd at the end
        }
    }
    di _col(1) "-------------" _col(14) "+"  _col(15) "-------------------------------------------------------------------------------"
    di _col(5) "Variable" _col(14) "|"  _col(22) "Obs" _col(33) "Mean" _col(41) "Std. Dev." _col(52) "Old Mean" _col(66) "Old SD" _col(76) "Old Min" _col(87) "Old Max"

    local j = 1
    foreach nam in i1.Ndegsel i2.Ndegsel i3.Ndegsel {
        qui sum `nam' if ccvar==1
        local N = r(N)
        local m0 = r(mean)
        local sd0 = r(sd)
        if "`nam'"=="i`j'.Ndegsel" {
            local i = 1
            while `i' <= 20 {
                qui sum i`j'._`i'_Ndegsel if ccvar==1
                local m`i' = r(mean)
                local s`i' = r(sd)
                local i = `i' + 1
            }
            local mean = (`m1'+`m2'+`m3'+`m4'+`m5'+`m6'+`m7'+`m8'+`m9'+`m10'+`m11'+`m12'+`m13'+`m14'+`m15'+`m16'+`m17'+`m18'+`m19'+`m20')/20
            local sd = (`s1'+`s2'+`s3'+`s4'+`s5'+`s6'+`s7'+`s8'+`s9'+`s10'+`s11'+`s12'+`s13'+`s14'+`s15'+`s16'+`s17'+`s18'+`s19'+`s20')/20
        }
        if `j'==1 {
            di %12s "1.Include" _col(14) "|" _col(19) %6.0f `N' _col(27) %10.5f `mean' _col(39) %10.5f `sd' _col(52) %10.5f `m0'  _col(66) %10.5f `sd0'
        }
        if `j'==2 {
            di %12s "2.Select" _col(14) "|" _col(19) %6.0f `N' _col(27) %10.5f `mean' _col(39) %10.5f `sd' _col(52) %10.5f `m0'  _col(66) %10.5f `sd0'
        }
        if `j'==3 {
            di %12s "3.MoreSelect" _col(14) "|" _col(19) %6.0f `N' _col(27) %10.5f `mean' _col(39) %10.5f `sd' _col(52) %10.5f `m0'  _col(66) %10.5f `sd0'
        }
        local j = `j' + 1
    }
    di _col(1) "-------------" _col(14) "+"  _col(15) "-------------------------------------------------------------"
    di _col(5) "Variable" _col(14) "|"  _col(22) "Obs" _col(33) "Mean" _col(41) "Std. Dev." _col(54) "Old Mean" _col(70) "Old SD"

    foreach nam in Accept0712 Private pellper0712 np_linc0813K Nmininst perWomen perBlkHis perSTEM lnendow0712K schsize0712K {
        qui sum `nam' if ccvar==1
        local N = r(N)
        local mean = r(mean)
            local m0 = `mean'
        local sd = r(sd)
            local sd0 = `sd'
        local min = r(min)
        local max = r(max)
        if `N' == 1082 {
            di %12s "`nam'" _col(14) "|" _col(19) %6.0f `N' _col(27) %10.5f `mean' _col(39) %10.5f `sd'  _col(73) %10.5f `min'  _col(84) %10.5f `max'  
        } 
        else {
            local i = 1
            while `i' <= 20 {
                qui sum _`i'_`nam' if ccvar==1
                local m`i' = r(mean)
                local s`i' = r(sd)
                local i = `i' + 1
            }
            local mean = (`m1'+`m2'+`m3'+`m4'+`m5'+`m6'+`m7'+`m8'+`m9'+`m10'+`m11'+`m12'+`m13'+`m14'+`m15'+`m16'+`m17'+`m18'+`m19'+`m20')/20
            local sd = (`s1'+`s2'+`s3'+`s4'+`s5'+`s6'+`s7'+`s8'+`s9'+`s10'+`s11'+`s12'+`s13'+`s14'+`s15'+`s16'+`s17'+`s18'+`s19'+`s20')/20
            di %12s "`nam'" _col(14) "|" _col(19) %6.0f `N' _col(27) %10.5f `mean' _col(39) %10.5f `sd' _col(50) %10.5f `m0'  _col(62) %10.5f `sd0' _col(73) %10.5f `min'  _col(84) %10.5f `max'  
            // if N !=1082, show original mean and sd at the end
        }
    }
    di _col(1) "-------------" _col(14) "+"  _col(15) "-------------------------------------------------------------------------------"
    di _col(5) "Variable" _col(14) "|"  _col(22) "Obs" _col(33) "Mean" _col(41) "Std. Dev." _col(52) "Old Mean" _col(66) "Old SD" _col(76) "Old Min" _col(87) "Old Max"

    foreach nam in ibn.urbanicity4 ibn.Region{
        sum `nam' if ccvar==1
    }
    di _col(1) "-------------" _col(14) "+"  _col(15) "-------------------------------------------------------------------------------"
    di _col(5) "Variable" _col(14) "|"  _col(22) "Obs" _col(33) "Mean" _col(41) "Std. Dev." _col(52) "Old Mean" _col(66) "Old SD" _col(76) "Old Min" _col(87) "Old Max"

    notes list Findnotes Anotes Qnotes Samplenotes
    notes list `Ys' `Xs' `Select' `Controls'

log close

