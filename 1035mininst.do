*** do 1035mininst

local do "1035"
local tag "$tag/`do'" 

 ** Minority Instiution
 
    local oldvar "mininst"
    local newvar "Nmininst"
    local varlab "Minority Serving Institution"
    global addvars "$addvars `newvar'"
    
    clonevar `newvar' = `oldvar'
    lab var `newvar' "`varlab'"
    recode `newvar' 1/3=1
    lab val `newvar' dichfmt
    note `newvar': [`oldvar'] `varlab'. 35 schools have missing values. | `tag'

    tab `newvar', m

