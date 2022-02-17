*** do 1036stucomp
 ** % Women in 2013
 ** % Black and Hispanic in 2013

local do "1036"
local tag "$tag/`do'" 

    tab totenrl13, m
    tab totwom, m
    
    local oldvar "totwom"
    local newvar "perWomen"
    local varlab "% Women enrolled in 2013"
    global addvars "$addvars `newvar'"
    gen `newvar' = `oldvar'/totenrl13 * 100
    lab var `newvar' "`varlab'"
    note `newvar': [`oldvar'] % Women enrolled in 2013. This is the number of /// 
         women enrolled in 2013 by the number of total enrolled in 2013 divided ///
         multiplied by 100. | `tag'

    tab `newvar', m

    tab black, m
    tab hisp, m

    local oldvar "black hisp"
    local newvar "perBlkHis"
    local varlab "% Black & Hispanic students enrolled in 2013"
    global addvars "$addvars `newvar'"
    gen `newvar' = (black + hisp) / totenrl13 * 100
    lab var `newvar' "`varlab'"
    note `newvar': [`oldvar'] Black & Hispanic students enrolled in 2013. This /// 
         is the number of Black & Hispanic students enrolled in 2013 divided by ///
         the number of total enrolled in 2013 multiplied by 100. | `tag'

    tab `newvar', m

