*** do 1033region

local do "1033"
local tag "$tag/`do'" 

 ** Region
    
    gen northern= (state=="CT" | state=="DE" | state=="ME" | state=="MD" | /// 
                   state=="MA" | state=="NH" | state=="NJ" | state=="NY" | /// 
                   state=="PA" | state=="RI" | state=="VT" | state=="DC")

    gen central=  (state=="IL" | state=="IN" | state=="IA" | state=="KY" | ///
                   state=="MI" | state=="MN" | state=="MO" | state=="OH" | ///
                   state=="WI")

    gen pacific=  (state=="AK" | state=="AZ" | state=="CA" | state=="HI" | ///
                   state=="NV" | state=="OR" | state=="UT" | state=="WA")

    gen southern= (state=="AL" | state=="AR" | state=="FL" | state=="GA" | /// 
                   state=="LA" | state=="MS" | state=="NC" | state=="SC" | /// 
                   state=="TN" | state=="VA" | state=="WV")
    
    gen western=  (state=="CO" | state=="ID" | state=="KS" | state=="MT" | /// 
                   state=="NE" | state=="NM" | state=="ND" | state=="OK" | /// 
                   state=="SD"| state=="TX" | state=="WY")

    // tab state if northern!=1 & central !=1 & pacific!=1 & southern!=1 & western!=1, m

    local oldvar "state"
    local newvar "Region"
    local varlab "Geographic region"
    global addvars "$addvars `newvar'"
    gen `newvar' = .
    lab var `newvar' "`varlab'"

    local i = 1
    foreach var of varlist northern central pacific southern western {
        recode `newvar' .=`i' if `var'==1
        label define `newvar' `i' "`var'", add
        local tmplab "`tmplab' `i' = `var',"
        local i = `i' + 1
    }
    lab val `newvar' `newvar'
    note `newvar': [`oldvar'] `varlab'. `tmplab'. | `tag'

    // tab `oldvar' `newvar', m // verfied
    tab `newvar', m

*** Urbanicity

    local oldvar "locale"
    local newvar "urbanicity4"
    local varlab "1=city, 4=rural"
    global addvars "$addvars `newvar'"
    clonevar `newvar' = `oldvar'
    lab var `newvar' "`varlab'"
    note `newvar': [`oldvar'] coded as 1= city, 2=suburb, 3=town, and 4=rural. | `tag'

    tab `newvar', m

    local oldvar "urbanicity4"
    local newvar "urbanicity"
    local varlab "1=city, 2=suburban/town, 3=rural"
    global addvars "$addvars `newvar'"
    clonevar `newvar' = `oldvar'
    recode `newvar' 2/3=2 4=3
    lab var `newvar' "`varlab'"
    lab def urbanicity3 1 "City" 2 "Suburban/town" 3 "Rural"
    lab val urbanicity urbanicity3
    note `newvar': [`oldvar' <= locale] coded as 1= city, 2=suburb/town, and 3=rural. | `tag'
    
    tab urbanicity4 urbanicity, m
    notes list urbanicity4 urbanicity
    notes drop urbanicity in 1
    notes renumber urbanicity
    notes list urbanicity4 urbanicity
