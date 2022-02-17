*** do 1020KeyXs

local do "1020"
local tag "$tag/`do'" 

*** Key Xs

 ** % Fraternity members

    local oldvar "fratmen"
    local newvar "perfrat"
    local varlab "% undergrad men as fraternity members"
    global addvars "$addvars `newvar'"
    gen `newvar' = `oldvar'*100
    replace `newvar' = `oldvar'1*100 if `oldvar'>=.
    lab var `newvar' "`varlab'"

    codebook `oldvar' `newvar', compact

    note `newvar': [`oldvar'] `varlab'. 916 cases are from the PIF dataset. 202 /// 
         missing cases are imputed using numbers pulled from USN 2013-2014 /// 
         (instead of 12-13, for which the value was missing) or a consumer /// 
         website. These numbers should be pretty accurate, as we wouldn’t ///
         expect much change in percent greek from 2012-2013 to 2013-2014. | `tag'

 ** % Sorority members

    local oldvar "sororwomen"
    local newvar "persoror"
    local varlab "% undergrad women as sorority members"
    global addvars "$addvars `newvar'"
    gen `newvar' = `oldvar'*100
    replace `newvar' = `oldvar'1*100 if `oldvar'>=.
    lab var `newvar' "`varlab'"

    codebook `oldvar' `newvar', compact

    note `newvar': [`oldvar'] `varlab'. 916 cases are from the PIF dataset. 198 /// 
         missing cases are imputed using numbers pulled from USN 2013-2014 /// 
         (instead of 12-13, for which the value was missing) or a consumer /// 
         website. These numbers should be pretty accurate, as we wouldn’t ///
         expect much change in percent greek from 2012-2013 to 2013-2014. | `tag'

 ** % Greek society members, weighted by gender ratio of student body and % fraternity & sorority members

    local newvar "perGreek"
    local varlab "% students as Greek members"
    global addvars "$addvars `newvar'"
    gen `newvar' = 100*(((perfrat/100)*totmen + (persoror/100)*totwom) / (totmen + totwom))
    lab var `newvar' "`varlab'"

    sum unitid perfrat persoror perGreek
    sum unitid perfrat persoror perGreek if pellgap<.


    note `newvar': `varlab'. This is calculated by 1) % undergrad men as /// 
         fraternity members (perfrat) multiplied total men enrolled in 2013 /// 
         (totmen), plus 2) % undergrad women as sorority members (persoror) /// 
         multiplied total women enrolled in 2013 (totwom), and then divided by /// 
         3) sum of total men and total women enrolled (totmen + totwom). 268 /// 
         cases have missing values because they miss either (perfrat) or /// 
         (persoror). These cases must be imputed. | `tag'
   
*** Campus Includes Greek Housing

    local oldvar "greek_house"
    local newvar "greekyes"
    local varlab "Campus Includes Greek Housing?"
    global addvars "$addvars `newvar'"
    clonevar `newvar' = `oldvar'
    lab var `newvar' "`varlab'"

    codebook `oldvar' `newvar', compact

    note `newvar': [`oldvar'] Whether or not Greek houses have on-campus /// 
         housing/property (yes = 1). It was our best estimation with all /// 
         the possible info from multiple different sites covering available /// 
         campus housing. This measure is useful as it is the best way to /// 
         dichotomize our key independent variable. Property is a signifier /// 
         of the power that Greek houses have. In many cases there may exist /// 
         a small, or even sizable, Greek population, but without chapter /// 
         houses they don’t have much effect on campus. This is a more /// 
         analytically sound dichotomous measure than say 0 % fratmen vs. any /// 
         other percent. Our main analyses will consider continuous percent /// 
         fraternity men, but supplemental analyses should consider a dichotomous ///
         measure, and percent sorority. Hence, the utility of this. I think this /// 
         dataset has values for all the cases that are in the current universe /// 
         (I hope). There are a number of missing here, but we did our best. | `tag'

