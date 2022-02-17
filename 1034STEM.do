*** do 1034STEM

local do "1034"
local tag "$tag/`do'" 

    local oldvar "tot_compsci tot_engin tot_lifesci tot_math tot_physci tot_totmaj"
    local newvar "perSTEM"
    local varlab "% graduating STEM majors 12-3"
    global addvars "$addvars `newvar'"
    gen `newvar' = ((tot_compsci + tot_engin + tot_lifesci + tot_math + tot_physci) / tot_totmaj) * 100
    lab var `newvar' "`varlab'"
    note `newvar': [`oldvar'] Percent of graduating majors in STEM in 12-13 /// 
         academic year. This is the number of graduating majors in STEM majors ///
         divided by the number of total graduating in the academic year 12-13 ///
         multiplied by 100. | `tag'

    codebook `newvar' `oldvar', compact
 