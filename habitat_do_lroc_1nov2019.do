***ran lroc again by witholding each sample unit (camera station) to make predictions (1 Nov 2019)

**removed Week from all models after checking impact on VIF scores (June 5 2019)

cd H:\DBreault\marten

set more off

clear

log using log_lroc_1nov2019.log, replace

*import logistic regression (0/1) version of data and run with roctab to check predictions

import excel using biweek_detect_covariates_1nov2019, first clear
destring detect, replace

/*Do file for performing jackknife ROC sampling - do file will construct a predicted probability for each case without using that case to generate coefficients
To run do file ensure that all cases are numbered (i.e., gen "count_id"). You can run the LROC for each model in the single do file; cut and paste
the set of commands and then change the model variables (e.g., 'logit presabs...'*/
*Drop cases that are outliers, unwanted seasons etc
*keep if (seasonspec == "LW2")

gen count_id = _n
gen LROC_P_ave_Marten_Model_Disturb=.

local No_Obs =_N

forval num = 1(1)`No_Obs' {
    melogit detect cut_100 edge_100 quad_edge_100 roads_100 quad_road_100 cluster year AvgOfAvgOfTemp_C if(grid_cell~=`num') || grid_cell :, intpoints(10) 
    predict p if (grid_cell==`num')
    rename p p_case_`num'
    replace LROC_P_ave_Marten_Model_Disturb = p_case_`num' if p_case_`num'~=.
    drop p_case_*
}

gen LROC_P_ave_Marten_Model_bias=.

local No_Obs =_N

forval num = 1(1)`No_Obs' {
    melogit detect cluster year AvgOfAvgOfTemp_C if(grid_cell~=`num') || grid_cell :, intpoints(10) 
    predict p if (grid_cell==`num')
    rename p p_case_`num'
    replace LROC_P_ave_Marten_Model_bias = p_case_`num' if p_case_`num'~=.
    drop p_case_*
}

gen LROC_P_ave_Marten_Model_marine=.

local No_Obs =_N

forval num = 1(1)`No_Obs' {
    melogit detect dist_marine quad_marine cluster year AvgOfAvgOfTemp_C if(grid_cell~=`num') || grid_cell :, intpoints(10) 
    predict p if (grid_cell==`num')
    rename p p_case_`num'
    replace LROC_P_ave_Marten_Model_marine = p_case_`num' if p_case_`num'~=.
    drop p_case_*
}

gen LROC_P_ave_Marten_Model_riparian=.

local No_Obs =_N

forval num = 1(1)`No_Obs' {
    melogit detect dist_riparian quad_riparian cluster year AvgOfAvgOfTemp_C if(grid_cell~=`num') || grid_cell :, intpoints(10) 
    predict p if (grid_cell==`num')
    rename p p_case_`num'
    replace LROC_P_ave_Marten_Model_riparian = p_case_`num' if p_case_`num'~=.
    drop p_case_*
}

roctab detect LROC_P_ave_Marten_Model_Disturb
roctab detect LROC_P_ave_Marten_Model_bias
roctab detect LROC_P_ave_Marten_Model_marine
roctab detect LROC_P_ave_Marten_Model_riparian

log close
