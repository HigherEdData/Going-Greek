*** do 1043percfirstgen

local do "1043"
local tag "$tag/`do'" 

 ** Percent first-gen on campus
    
    local oldvar "first_gen"
    local newvar "percG1"
    local varlab "% 1st-generation students"
    global addvars "$addvars `newvar'"

    recode `oldvar' -9999=. -99=.
    gen `newvar' = `oldvar' * 100
    lab var `newvar' "`varlab'"
    note `newvar': [`oldvar'] % of first-generation students. | `tag'
    note `newvar': 10 cases have -99, coded as missing. | `tag'

    codebook `newvar', compact

