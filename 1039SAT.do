*** do 1039SAT

local do "1039"
local tag "$tag/`do'" 

 ** Average SAT scores
    
    local oldvar "sat_avg"
    local newvar "Nsat_avg"
    local varlab "Average SAT equivalent scores"
    global addvars "$addvars `newvar'"

    clonevar `newvar' = `oldvar'
    lab var `newvar' "`varlab'"
    sum `oldvar' `newvar'
    recode `newvar' -99=.
    sum `oldvar' `newvar'

    list unitid instnm Nsat_avg if Nsat_avg<800, clean noob

    note `newvar': [`oldvar'] Average SAT equivalent score of students admitted. ///
         The SAT average is a constructed item from Scorecard using IPEDS data. /// 
         Laura thinks that this variable is from 13-14, but there seems to be a /// 
         lack of clear documentation. IPEDS reports the 25th and 75th percentiles /// 
         of admitted students for all three SAT subjects. Scorecard used this /// 
         info to construct an overall average. The exact equation is not obvious, /// 
         From what I can see, it seems that the equation is (sat_avg = reading + /// 
         math + writing). For each of the subject, the score is the average of /// 
         the 25th and 75th percentiles. Some schools used all three subjects /// 
         and thus have higher scores in sat_avg, and some schools used only /// 
         reading and math. 10 schools have scores lower than 800. It’s possible /// 
         that these schools used 1 or 2 subjects in the calculation. One may /// 
         judge this by looking ///
         at what school it is. | `tag' 

    note `newvar': I don't know exactly how Scorecard construct the average SAT ///
         scores, but I like the idea of taking average from the scores based on /// 
         25 and 75 percentiles. This means that extreme scores are excluded from /// 
         the calculations. Scores from 25th and 75th percentiles, like medians, /// 
         are less affected by extreme values. If we can, we should using average /// 
         scores of 25th and 75th percentiles from 2007-2012 data. This has 2 /// 
         advantages--it takes care year variations, and it is not affected ///
         by extreme values. | `tag' 
         
    note `newvar': 160 schools have -99 (NULL). These are likely schools /// 
         that require no SAT. We should think how to deal with this. Should /// 
         not be simply missing values. | `tag'

*** Average SAT 07-13

 ** Check variables
 
    nmlab Nsat_avg sub_SAT_1213-SAT_Writ_75_0708 sub_SAT_1314-SAT_Writ_75_1314

    list unitid Nsat_avg sub_SAT_1213 SAT_critread_25_1213 SAT_critread_75_1213 /// 
                SAT_math_25_1213 SAT_math_75_1213 SAT_Writ_25_1213 SAT_Writ_75_1213 ///
                in 1/100, clean noob

 ** Average reading, math, and writing scores for 0708 0809 0910 1011 1112 1213
    
    foreach nam in 0708 0809 0910 1011 1112 1213 1314 {

        qui gen read`nam' = (SAT_critread_25_`nam' + SAT_critread_75_`nam') / 2
        qui gen math`nam' = (SAT_math_25_`nam' + SAT_math_75_`nam') / 2 
        qui gen writ`nam' = (SAT_Writ_25_`nam' + SAT_Writ_75_`nam') / 2

        qui gen coun`nam' = 0 // # of subjects available for a given year
        qui replace coun`nam' = coun`nam' + 1 if read`nam'<.
        qui replace coun`nam' = coun`nam' + 1 if math`nam'<.
        qui replace coun`nam' = coun`nam' + 1 if writ`nam'<.

        qui alpha read`nam' math`nam' writ`nam', gen(avgSAT`nam')
        lab var avgSAT`nam' "Average SAT scores `nam'"
    }

    sum coun1213 read1213 math1213 writ1213 coun1112 read1112 math1112 writ1112 /// 
        coun1011 read1011 math1011 writ1011 coun0910 read0910 math0910 writ0910 /// 
        coun0809 read0809 math0809 writ0809 coun0708 read0708 math0708 writ0708 Nsat_avg, sep(4) 

 ** Calculate average SAT scores 07-13
 
    local oldvar "avgSAT1213 avgSAT1112 avgSAT1011 avgSAT0910 avgSAT0809 avgSAT0708"
    local newvar "avgSAT0713"
    local varlab "Average SAT scores 07-13"
    global addvars "$addvars `newvar'"

    alpha `oldvar', gen(`newvar') 
    lab var `newvar' "`varlab'"

    codebook avgSAT0713 avgSAT0708 avgSAT0809 avgSAT0910 avgSAT1011 avgSAT1112 avgSAT1213 avgSAT1314, compact

    note `newvar': To construct average SAT scores for 07-13, we need to /// 
         check how sat_avg was calculated. I compared sat_avg values with the /// 
         values of the 25th and 75th percentiles for three subjects from /// 
         previous years. From what I can see, it seems that the equation is /// 
         (sat_avg = reading + math + writing). For each of the subject, the /// 
         score is the average of the 25th and 75th percentiles. Some schools /// 
         used all three subjects and thus have higher scores in sat_avg, and /// 
         some schools used only reading and math. | `tag' 

    note `newvar': The decision of using 2 or 3 subjects affects the ///
         values in sat_avg. In our calculation of average SAT scores from 2007 /// 
         to 2013, we want to avoid the noises caused by this decision. So, it /// 
         makes sense to use the average of the available scores for the 3 /// 
         subjects instead of the sum. This approach also makes sense because /// 
         the availability of the scores for different subjects vary across /// 
         schools and sometimes vary across years for the same school. Using /// 
         this method, we can have the average scores of three subjects. Then, /// 
         we can take the average across years. | `tag' 

    note `newvar': Using this method, we have scores for 1215 of the 1380 ///
         schools in the data. Of the schools that have missing values, 70 /// 
         schools have valid values in avgSAT1314 or sat_avg. We use the /// 
         subject average scores for these 70 schools to reduce the missing. /// 
         cases. | `tag'

 ** Check how [sat_avg] from PIF corresponds with 13-14 & 12-13 measures

    sort Nsat_avg, stable

    list unitid instnm Nsat_avg avgSAT1314 avgSAT0713 if avgSAT0713>=. & (avgSAT1314<. | Nsat_avg<.), clean noob
    count if avgSAT0713>=. & (avgSAT1314<. | Nsat_avg<.)
    replace avgSAT0713=avgSAT1314 if avgSAT1314<. & avgSAT0713>=.

    list unitid instnm Nsat_avg avgSAT0713 Ndegsel if Nsat_avg<. & avgSAT0713>=., clean noob
    count if Nsat_avg<. & avgSAT0713>=.
    replace avgSAT0713=Nsat_avg/2 if Nsat_avg<. & avgSAT0713>=.
    codebook avgSAT0713 avgSAT0708 avgSAT0809 avgSAT0910 avgSAT1011 avgSAT1112 avgSAT1213 avgSAT1314 Nsat_avg, compact

    note `newvar': This is for ourselves only--Of these 70 schools, 14 are ///
         imputed using avgSAT1314. The remaining 56 schools do not have ///
         avgSAT1314. We then check their selectivity and Nsat_avg scores to ///
         confirm that the the Nsat_avg scores of all 56 schools should be ///
         divided by 2.
         
    note `newvar': The *sub* measures (sub_SAT_1213 sub_SAT_1112 sub_SAT_1011 ///
         sub_SAT_0910 sub_SAT_0809 sub_SAT_0708) are the percentage of 1st-time /// 
         degree seeking students at a school who submitted SAT scores. We may ///
         not need this in analyses, but it might be a useful in some way down /// 
         the line. Some schools are going to have SAT scores based on a very /// 
         small proportion of students, as they might not be required for ///
         admission, while others have scores for virtually every student they ///
         admit. | `tag'

