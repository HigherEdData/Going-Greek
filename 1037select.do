*** do 1037select

local do "1037"
local tag "$tag/`do'" 

 ** Degree of selectivitiy

    local oldvar "degsel"
    local newvar "Ndegsel"
    local varlab "Degree of selectivitiy"
    global addvars "$addvars `newvar'"

    clonevar `newvar' = `oldvar'
    lab var `newvar' "`varlab'"
    note `newvar': [`oldvar'] Degree of selectivitiy based on Carnegie /// 
         Classifications. 1 = Inclusive, 2 = Selective, 3 = More selective. ///
         57 cases have missing values. Laura has access to finely grained /// 
         selectivity measures that we will need to use--Barron's Index--but /// 
         it is restricted access. | `tag'
    tab `oldvar' `newvar', m

    note `newvar': There is the issue of a better measure for selectivity. /// 
         IPEDS only has the three-category Carnegie measure. Barron’s is better. /// 
         But for some unknown reason it is restricted access NCES. /// 
         http://nces.ed.gov/pubsearch/pubsinfo.asp?pubid=2010331. I have used /// 
         the 1992 and 2004 Barron’s and have them in my NCES lab now, but we /// 
         would want 2008. Problem is, if it is restricted data---even though it /// 
         is not individually identifiable, apparently analyses with it need /// 
         to be run in NCES approved labs. | `tag' 

    note `newvar': The difference between Carnegie and Barron’s /// 
         competitiveness index is relatively slight. Barron’s is a tiny bit more /// 
         detailed. Instead of three categories it has four: 1=most competitive, /// 
         2=highly competitive plus, 3=highly competitive, 4=very competitive /// 
         plus. The difference is at the top end, disaggregating really elite /// 
         schools from those that are pretty selective, but not incredibly /// 
         selective. I am ok using the Carnegie measure, as we have other /// 
         indicators that get to the issue of selectivity (like acceptance rate and SAT). | `tag' 

    note `newvar': The good news is that most everyone just uses the Carnegie /// 
         selectivity measure that we already have. So that settles that. If we /// 
         were to drop a measure of selectivity, it would be SAT score. But right /// 
         now I think people will want both. | `tag' 