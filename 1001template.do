*** do 1001template

*** Template

/* 
    Template
    local oldvar ""
    local newvar ""
    local varlab ""
    global addvars "$addvars `newvar'"
    clonevar `newvar' = `oldvar'
    lab var `newvar' "`varlab'"
    note `newvar': [`oldvar']  / `tag'

    recode `newvar' -99=.
    tab `oldvar' `newvar', m
*/
