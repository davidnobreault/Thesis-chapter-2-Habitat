*logistic regression of biweekly detection data in all sorts of ways:
*mixed effects ordered logistic regression
*ordered logistic regression with brant test
*mixed effect logistic regression with predicted probabilities and roc test
*logistic regression with clustered variance adjustment

**removed Week from all models after checking impact on VIF scores (June 5 2019)

cd H:\DBreault\marten

set more off

clear

log using log_log_regress_5jun2019_v02.log, replace

*import logistic regression (0/1) version of data and run with roctab to check predictions

import excel using biweek_detect_covariates_18dec2018_v08, first clear
destring detect, replace

melogit detect || grid_cell :, intpoints(10)
capture drop predicted_probability
predict predicted_probability, mu
roctab detect predicted_probability

melogit detect Week || grid_cell :, intpoints(10)
capture drop predicted_probability
predict predicted_probability, mu
roctab detect predicted_probability

melogit detect cluster || grid_cell :, intpoints(10)
capture drop predicted_probability
predict predicted_probability, mu
roctab detect predicted_probability

melogit detect year || grid_cell :, intpoints(10)
capture drop predicted_probability
predict predicted_probability, mu
roctab detect predicted_probability

melogit detect Week cluster year || grid_cell :, intpoints(10)
capture drop predicted_probability
predict predicted_probability, mu
roctab detect predicted_probability

melogit detect cluster year AvgOfAvgOfTemp_C || grid_cell :, intpoints(10)
capture drop predicted_probability
predict predicted_probability, mu
roctab detect predicted_probability

melogit detect trap_density_1000|| grid_cell :, intpoints(10)
capture drop predicted_probability
predict predicted_probability, mu
roctab detect predicted_probability

melogit detect trap_density_1000 cluster year AvgOfAvgOfTemp_C|| grid_cell :, intpoints(10)
capture drop predicted_probability
predict predicted_probability, mu
roctab detect predicted_probability

melogit detect pr_avg_2 pr_avg_3 cluster year AvgOfAvgOfTemp_C || grid_cell :, intpoints(10)
capture drop predicted_probability
predict predicted_probability, mu
roctab detect predicted_probability

melogit detect pct_vricc3 cluster year AvgOfAvgOfTemp_C|| grid_cell :, intpoints(10)
capture drop predicted_probability
predict predicted_probability, mu
roctab detect predicted_probability

melogit detect pct_vricc3 pr_avg_3 prop_o250 cluster year AvgOfAvgOfTemp_C|| grid_cell :, intpoints(10)
capture drop predicted_probability
predict predicted_probability, mu
roctab detect predicted_probability

melogit detect pr_sc01_1000 cluster year AvgOfAvgOfTemp_C|| grid_cell :, intpoints(10)
capture drop predicted_probability
predict predicted_probability, mu
roctab detect predicted_probability

melogit detect roads_1000 Quad_road_1000 pct_cut_1000 quad_cut_1000 cluster year AvgOfAvgOfTemp_C|| grid_cell :, intpoints(10)
capture drop predicted_probability
predict predicted_probability, mu
roctab detect predicted_probability

melogit detect active_1000 abandon_1000 Quad_aban_1000 edge_1000 quad_edge_1000 cluster year AvgOfAvgOfTemp_C|| grid_cell :, intpoints(10)
capture drop predicted_probability
predict predicted_probability, mu
roctab detect predicted_probability

melogit detect age1_100 cluster year AvgOfAvgOfTemp_C|| grid_cell :, intpoints(10)
capture drop predicted_probability
predict predicted_probability, mu
roctab detect predicted_probability

melogit detect pr_lidcov pr_lidavg pr_sc01_100 cluster year AvgOfAvgOfTemp_C || grid_cell :, intpoints(10)
capture drop predicted_probability
predict predicted_probability, mu
roctab detect predicted_probability

melogit detect dist_marine quad_marine cluster year AvgOfAvgOfTemp_C|| grid_cell :, intpoints(10)
capture drop predicted_probability
predict predicted_probability, mu
roctab detect predicted_probability

melogit detect dist_riparian quad_riparian cluster year AvgOfAvgOfTemp_C|| grid_cell :, intpoints(10)
capture drop predicted_probability
predict predicted_probability, mu
roctab detect predicted_probability

melogit detect cut_100 edge_100 quad_edge_100 roads_100 quad_road_100 cluster year AvgOfAvgOfTemp_C|| grid_cell :, intpoints(10)
capture drop predicted_probability
predict predicted_probability, mu
roctab detect predicted_probability

melogit detect aban_100 quad_aban_100 active_100 cluster year AvgOfAvgOfTemp_C|| grid_cell :, intpoints(10)
capture drop predicted_probability
predict predicted_probability, mu
roctab detect predicted_probability

save biweek_detect_covariates_5jun2019.dta, replace

*check VIF scores for all models

regress detect cluster year AvgOfAvgOfTemp_C
vif

regress detect trap_density_1000 cluster year AvgOfAvgOfTemp_C
vif

regress detect pr_avg_2 pr_avg_3 cluster year AvgOfAvgOfTemp_C
vif

regress detect pct_vricc3 cluster year AvgOfAvgOfTemp_C
vif

regress detect pct_vricc3 pr_avg_3 prop_o250 cluster year AvgOfAvgOfTemp_C
vif

regress detect pr_sc01_1000 cluster year AvgOfAvgOfTemp_C
vif

regress detect roads_1000 pct_cut_1000 cluster year AvgOfAvgOfTemp_C
vif

regress detect active_1000 abandon_1000 edge_1000 cluster year AvgOfAvgOfTemp_C
vif

regress detect age1_100 cluster year AvgOfAvgOfTemp_C
vif

regress detect pr_lidcov pr_lidavg pr_sc01_100 cluster year AvgOfAvgOfTemp_C
vif

regress detect dist_marine cluster year AvgOfAvgOfTemp_C
vif

regress detect dist_riparian cluster year AvgOfAvgOfTemp_C
vif

regress detect cut_100 edge_100 roads_100 cluster year AvgOfAvgOfTemp_C
vif

regress detect aban_100 active_100 cluster year AvgOfAvgOfTemp_C
vif

/*Do file for performing jackknife ROC sampling - do file will construct a predicted probability for each case without using that case to generate coefficients
To run do file ensure that all cases are numbered (i.e., gen "count_id"). You can run the LROC for each model in the single do file; cut and paste
the set of commands and then change the model variables (e.g., 'logit presabs...'*/
*Drop cases that are outliers, unwanted seasons etc
*keep if (seasonspec == "LW2")

gen count_id = _n
gen LROC_P_ave_Marten_Model_Disturb=.

local No_Obs =_N

forval num = 1(1)`No_Obs' {
    melogit detect cut_100 edge_100 quad_edge_100 roads_100 quad_road_100 cluster year AvgOfAvgOfTemp_C if(count_id~=`num') || grid_cell :, intpoints(10) 
    predict p if (count_id==`num')
    rename p p_case_`num'
    replace LROC_P_ave_Marten_Model_Disturb = p_case_`num' if p_case_`num'~=.
    drop p_case_*
}

gen LROC_P_ave_Marten_Model_bias=.

local No_Obs =_N

forval num = 1(1)`No_Obs' {
    melogit detect cluster year AvgOfAvgOfTemp_C if(count_id~=`num') || grid_cell :, intpoints(10) 
    predict p if (count_id==`num')
    rename p p_case_`num'
    replace LROC_P_ave_Marten_Model_bias = p_case_`num' if p_case_`num'~=.
    drop p_case_*
}

gen LROC_P_ave_Marten_Model_marine=.

local No_Obs =_N

forval num = 1(1)`No_Obs' {
    melogit detect dist_marine quad_marine cluster year AvgOfAvgOfTemp_C if(count_id~=`num') || grid_cell :, intpoints(10) 
    predict p if (count_id==`num')
    rename p p_case_`num'
    replace LROC_P_ave_Marten_Model_marine = p_case_`num' if p_case_`num'~=.
    drop p_case_*
}

gen LROC_P_ave_Marten_Model_riparian=.

local No_Obs =_N

forval num = 1(1)`No_Obs' {
    melogit detect dist_riparian quad_riparian cluster year AvgOfAvgOfTemp_C if(count_id~=`num') || grid_cell :, intpoints(10) 
    predict p if (count_id==`num')
    rename p p_case_`num'
    replace LROC_P_ave_Marten_Model_riparian = p_case_`num' if p_case_`num'~=.
    drop p_case_*
}

roctab detect LROC_P_ave_Marten_Model_Disturb
roctab detect LROC_P_ave_Marten_Model_bias
roctab detect LROC_P_ave_Marten_Model_marine
roctab detect LROC_P_ave_Marten_Model_riparian

log close
