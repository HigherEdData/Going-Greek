*** do 1002merge

local do "1002"
local tag "$tag/`do'" 
local mergedta "temp1.dta temp2.dta temp3.dta temp4.dta temp5.dta"

*** Check and merge data
    
 ** Data check

  * Data 1
  
    use "$dsold1", clear
    des unitid totenrl
    sum unitid totenrl
    
    sort unitid, stable
    // list unitid instnm totenrl in 1/10, clean noob
    codebook frat* soror*, compact
    save temp1, replace
    // keep unitid instnm
    // export excel idname, firstrow(variables)
    
  * Data 2

    use "$dsold2", clear

    sort unitid, stable
    desc unitid totenrl13
    sum unitid totenrl13
    nmlab
    // list unitid totenrl13 in 1/10, clean noob
    // compared and confirmed id match
    save temp2, replace

  * Data 3

    use "$dsold3", clear

    sort unitid, stable
    codebook, compact
    list unitid Greek_flag fratmen1 sororwomen1 if unitid<., clean noob
    save temp3, replace

  * Data 4

    use "$dsold4", clear

    sort unitid, stable
    codebook, compact
    save temp4, replace

  * Data 5

    use "$dsold5", clear

    sort unitid, stable
    codebook, compact
    save temp5, replace

 ** Data merge

    use temp1, clear
    merge 1:1 unitid using temp2
    keep if _merge==1 | _merge==3
    sum unitid totenrl totenrl13
    list unitid instnm totenrl totenrl13 in 1/10, clean noob
    drop _merge

    merge 1:1 unitid using temp3
    keep if _merge==1 | _merge==3
    drop _merge

    merge 1:1 unitid using temp4
    keep if _merge==1 | _merge==3
    drop _merge

    merge 1:1 unitid using temp5
    keep if _merge==1 | _merge==3
    drop _merge

    foreach nam in `mergedta' {
        erase `nam'
    }
