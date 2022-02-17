*** do 1010Ys

local do "1010"
local tag "$tag/`do'" 

*** Dependent Variable: Pell vs. non-Pell graduation rates come from two different sources
 ** Document the construction of the dependent variable from 2 datasources
    
 ** Source 1: US News and World Report

    codebook sixgradpell sixgradnonps
    tab sixgradpell, m
    tab sixgradnonps, m

    gen PellUSN = (sixgradpell<.)
    lab var PellUSN "Pell rates available in USN"
    lab val PellUSN yes
    tab PellUSN, m
    note PellUSN: Cases with available Pell grad rates from USN. | `tag'

 ** Source 2: Ed Trust data

    codebook pellgrad nonpellgrad, compact
    note pellgrad: This is from Ed Trust data. | `tag'
    note nonpellgrad: This is from Ed Trust data. | `tag'

    recode pellgrad -9999=.
    recode pellgrad -99=.

    recode nonpellgrad -9999=.
    recode nonpellgrad -99=.

    tab pellgrad, m
    tab nonpellgrad, m

    gen PellTrust = (pellgrad<.)
    lab var PellTrust "Pell rates available in Ed Trust"
    lab val PellTrust yes
    tab PellTrust, m
    note PellTrust: Cases with available Pell grad rates from Ed Trust. | `tag'

    tab PellTrust PellUSN, m

 ** Compare Pell student graduation rates from two sources
  * How comparable are USN data with EdTrust data?

    local newvar "pellcomp"
    gen `newvar' = pellgrad-sixgradpell
    lab var `newvar' "Compare Pell data from USN & EdTrust"
    global addvars "$addvars `newvar'"
    note `newvar': Compare Pell graduation rates from USN data & EdTrust data. | `tag'

    tab pellcomp, m
    tab pellcomp if pellcomp >=1 | pellcomp <=-1
    tab pellcomp if pellcomp >=5 | pellcomp <=-5

    note pellcomp: 584 missing in US News and World Report, 309 missing in /// 
         EdTrust. Among the available data from the two sources, 89 cases with /// 
         worrisome gaps (i.e., difference >=1%). 32 cases with very worrisome /// 
         gaps (i.e., difference >=5%). These 32 cases should be further checked, ///
         otherwise suggests very comparable data. | `tag'

 ** Compare non-Pell student graduation rates from two sources
  * How comparable are USN data with EdTrust data?

    local newvar "nonpellcomp"
    gen `newvar' = nonpellgrad-sixgradnonps
    lab var `newvar' "Compare non-Pell data from USN & EdTrust"
    global addvars "$addvars `newvar'"
    note `newvar': Compare non-Pell graduation rates from USN data & EdTrust data. | `tag'

    tab nonpellcomp, m
    tab nonpellcomp if nonpellcomp >=1 | nonpellcomp <=-1
    tab nonpellcomp if nonpellcomp >=5 | nonpellcomp <=-5

    note nonpellcomp: 588 missing in US News and World Report, 305 missing in /// 
         EdTrust. Among the available data from the two sources, 567 cases with /// 
         worrisome gaps (i.e., difference >=1%). 140 cases with very worrisome /// 
         gaps (i.e., difference >=5%). | `tag'

    note nonpellcomp: This is not surprising, given that these 6-year graduation /// 
         rates are constructed differently. USN is actually non-Pell, non-stafford /// 
         and EdTrust is non-Pell only. Furthermore, EdTrust is an extrapolation /// 
         from IPEDS. Ed Trust admits that USN data are better, but didn't purchase /// 
         them (neither did I, but currently only using for personal use, protected /// 
         under copyright law). | `tag'

 ** Generate Pell graduation rates measures

    local oldvar "pellgrad"
    local newvar "pellrates"
    local varlab "Pell graduation rates"
    global addvars "$addvars `newvar'"
    clonevar `newvar' = `oldvar'
    lab var `newvar' "`varlab'"
    replace `newvar' = sixgradpell if pellgrad==. & sixgradpell!=.

    tab `newvar', m

    note pellrates: Given that the EdTrust data are more complete, we use the /// 
         rates from EdTrust data as the primary source. Then supplement with /// 
         USN to gain 13 cases. After this, we have 296 cases missing for Pell /// 
         grad rate data. | `tag'

 ** Non-Pell graduation rates

    tab nonpellgrad if sixgradnonps==. & nonpellgrad!=.

    local oldvar "sixgradnonps"
    local newvar "nonpellrates"
    local varlab "non-Pell graduation rates"
    global addvars "$addvars `newvar'"
    clonevar `newvar' = `oldvar'
    lab var `newvar' "`varlab'"
    replace `newvar' = nonpellgrad if sixgradnonps==. & nonpellgrad!=.

    note `newvar': [`oldvar']  | `tag'

    tab `newvar', m

    note `newvar': Given the superior quality of USN data on this measure, /// 
         we use that as the primary source for non-Pell graduation rates. ///
         However, there are 293 cases missing in USN not missing in EdTrust. ///
         To keep up the N, we supplement with EdTrust, but will check on those /// 
         cases in analyses.  After this, we have 293 cases missing for non-Pell /// 
         grad rate data. | `tag'

  * Mark the 293 cases

    local newvar "nonpellmark"
    local varlab "Miss non-pell rates in USN not miss in EdTrust"
    global addvars "$addvars `newvar'"
    gen `newvar'=(sixgradnonps==. & nonpellgrad!=.)
    lab var `newvar' "`varlab'"

    tab `newvar', m

 ** Gap in Non-Pell vs. Pell graduation ratesc

    local oldvar ""
    local newvar "pellgap"
    local varlab "Gap in Non-Pell v Pell grad rates"
    global addvars "$addvars `newvar'"
 
    gen `newvar' = nonpellrates - pellrates
    lab var `newvar' "`varlab'"
    note `newvar': Gap in Non-Pell vs. Pell graduation rates = non-pell rates - pell rates. | `tag'

 ** Ratio in Non-Pell vs. Pell graduation rates
 
    local newvar "pellratio"
    local varlab "Ratio in Non-Pell v Pell grad rates"
    global addvars "$addvars `newvar'"
    gen `newvar' = nonpellrates / pellrates
    lab var `newvar' "`varlab'"

    recode `newvar' 0=.
    codebook pellgap pellratio, compact
    list unitid pellrates nonpellrates pellgap pellratio if pellgap<. & pellratio>=., clean

    note `newvar': Ratio in Pell vs. Non-Pell graduation rates = non-pell rates / pell rates. | `tag'

    note `newvar': Three cases have 0 in [nonpellrates] but non-zero in /// 
         [pellrates]. These 3 cases thus have 0 in [pellratio] and are coded as /// 
         missing, but they are not missing in [pellgap]. After checking with /// 
         Laura, these 3 cases are dropped from the analyses. See Laura's note /// 
         below from email 151113. | `tag'

    note `newvar': Laura's note below from email 151113-- These three cases /// 
         are probably correct, but they are problematic schools. They have /// 
         such very low graduation rates in general, and a majority students /// 
         are Pell (90% in one case) which is partly why we are seeing zero /// 
         for non-Pell. Also, it looks like Life University (one of the three ///
         cases), is now primarily a chiropractic college. I would go ahead and /// 
         drop all three from the analyses. | `tag'

    local reason "problematic cases in [nonpellrates] and thus [pellratio]"

    qui tab ccbasic, m
    local N = r(N)
    di `N'

    count if unitid==140252 | unitid==144005 | unitid==225885
    local n = r(N)

    drop if unitid==140252 | unitid==144005 | unitid==225885
    list unitid pellrates nonpellrates pellgap pellratio if pellgap<. & pellratio>=., clean
    local N = `N' - `n'

    note Samplenotes: N = `N', after drop `n' cases for: `reason'. See notes below and in [`newvar']. | `tag'
    note Samplenotes: These last 3 cases have 0 in [nonpellrates] but non-zero /// 
         in [pellrates]. So, they have missing values in [pellratio] but not ///
         [pellgap]. Laura's note from email 151113 suggests that these 3 cases /// 
         are probably correct, but they are problematic schools. They have /// 
         such very low graduation rates in general, and a majority students /// 
         are Pell (90% in one case) which is partly why we are seeing zero /// 
         for non-Pell. Also, it looks like Life University (one of the three ///
         cases), is now primarily a chiropractic college. I would go ahead and /// 
         drop all three from the analyses. | `tag'

*** Final sample note

    local reason "missing values in pap in Non-Pell vs. Pell graduation ratesc"

    count if pellgap>=.
    local n = r(N)

    local N = `N' - `n'

    note Samplenotes: N = `N' in final analyses because `n' cases are excluded for: `reason'. | `tag'
         
 ** # reported forcible sex offenses

    nmlab sexforcon sexforcoff, col(20)

    local oldvar "sexforcon"
    local newvar "forcsexcamp"
    local varlab "# forcible sex offenses on campus 12"
    global addvars "$addvars `newvar'"
    clonevar `newvar' = `oldvar'
    lab var `newvar' "`varlab'"
    qui sum `newvar' 
    local mn = r(mean)
    note `newvar': [sexforcon] Number of reported forcible sex offenses on /// 
         campus in 2012. This is a count variable. Mean = `mn'. | `tag'
    
    local oldvar "sexforcoff"
    local newvar "forcsexoffcamp"
    local varlab "# forcible sex offenses off campus 12"
    global addvars "$addvars `newvar'"
    clonevar `newvar' = `oldvar'
    lab var `newvar' "`varlab'"
    qui sum `newvar' 
    local mn = r(mean)
    note `newvar': [sexforcoff] Number of reported forcible sex offenses, /// 
         noncampus building or property in 2012. This is a count variable. ///
         Mean = `mn'. | `tag'

    nmlab forcsexcamp forcsexoffcamp, col(20)
    sum forcsexcamp forcsexoffcamp
    notes list forcsexcamp forcsexoffcamp
