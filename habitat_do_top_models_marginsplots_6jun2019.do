*graph predicted probabilities of detection using one covariate at a time from the top models

cd H:\DBreault\marten

set more off

log using log_margins_6jun2019.log, replace

import excel using biweek_detect_covariates_18dec2018_v08, first clear

destring detect, replace

*graph predicted probability with 95%CI with cut_100 as indep var

melogit detect cut_100 edge_100 quad_edge_100 roads_100 quad_road_100 cluster year AvgOfAvgOfTemp_C|| grid_cell :, intpoints(10)
summarize cut_100
margins, at(cut_100=(0(10)100)) atmeans vsquish post
marginsplot, recast(line) recastci(rarea)
graph save Graph "H:\DBreault\marten\marginsplot_cut_100_6jun2019.gph", replace

*repeat for all covariates in model except cluster and year (categorical independent variables)

melogit detect cut_100 edge_100 quad_edge_100 roads_100 quad_road_100 cluster year AvgOfAvgOfTemp_C|| grid_cell :, intpoints(10)
summarize edge_100
margins, at(edge_100=(0(0.5)7.269306)) atmeans vsquish post
marginsplot, recast(line) recastci(rarea)
graph save Graph "H:\DBreault\marten\marginsplot_edge_100_6jun2019.gph", replace

melogit detect cut_100 edge_100 quad_edge_100 roads_100 quad_road_100 cluster year AvgOfAvgOfTemp_C|| grid_cell :, intpoints(10)
summarize quad_edge_100
margins, at(quad_edge_100=(0(5)52.84281)) atmeans vsquish post
marginsplot, recast(line) recastci(rarea)
graph save Graph "H:\DBreault\marten\marginsplot_quad_edge_100_6jun2019.gph", replace

melogit detect cut_100 edge_100 quad_edge_100 roads_100 quad_road_100 cluster year AvgOfAvgOfTemp_C|| grid_cell :, intpoints(10)
summarize roads_100
margins, at(roads_100=(0(0.2)3.946626)) atmeans vsquish post
marginsplot, recast(line) recastci(rarea)
graph save Graph "H:\DBreault\marten\marginsplot_roads_100_6jun2019.gph", replace

melogit detect cut_100 edge_100 quad_edge_100 roads_100 quad_road_100 cluster year AvgOfAvgOfTemp_C|| grid_cell :, intpoints(10)
summarize quad_road_100
margins, at(quad_road_100=(0(1)15.57586)) atmeans vsquish post
marginsplot, recast(line) recastci(rarea)
graph save Graph "H:\DBreault\marten\marginsplot_quad_road_100_6jun2019.gph", replace

melogit detect cut_100 edge_100 quad_edge_100 roads_100 quad_road_100 cluster year AvgOfAvgOfTemp_C|| grid_cell :, intpoints(10)
summarize AvgOfAvgOfTemp_C
margins, at( AvgOfAvgOfTemp_C =(-2.487954 (1)7.655108)) atmeans vsquish post
marginsplot, recast(line) recastci(rarea)
graph save Graph "H:\DBreault\marten\marginsplot_AvgofAvgOfTemp_C_6jun2019.gph", replace

*repeat for distance to marine and distance to riparian models

melogit detect dist_marine quad_marine cluster year AvgOfAvgOfTemp_C|| grid_cell :, intpoints(10)
summarize dist_marine
margins, at( dist_marine =(.0390598 (1)14.985)) atmeans vsquish post
marginsplot, recast(line) recastci(rarea)
graph save Graph "H:\DBreault\marten\marginsplot_dist_marine_6jun2019.gph", replace

melogit detect dist_marine quad_marine cluster year AvgOfAvgOfTemp_C|| grid_cell :, intpoints(10)
summarize quad_marine
margins, at( quad_marine =(.0015257  (10)224.5502)) atmeans vsquish post
marginsplot, recast(line) recastci(rarea)
graph save Graph "H:\DBreault\marten\marginsplot_quad_marine_6jun2019.gph", replace

melogit detect dist_riparian quad_riparian cluster year AvgOfAvgOfTemp_C|| grid_cell :, intpoints(10)
summarize dist_riparian
margins, at( dist_riparian =(.0368665 (0.2)2.285872)) atmeans vsquish post
marginsplot, recast(line) recastci(rarea)
graph save Graph "H:\DBreault\marten\marginsplot_dist_riparian_6jun2019.gph", replace

melogit detect dist_riparian quad_riparian cluster year AvgOfAvgOfTemp_C|| grid_cell :, intpoints(10)
summarize quad_riparian
margins, at( quad_riparian =(.0013591  (0.5)5.22521)) atmeans vsquish post
marginsplot, recast(line) recastci(rarea)
graph save Graph "H:\DBreault\marten\marginsplot_quad_riparian_6jun2019.gph", replace

save biweek_detect_covariates_18dec2018_v08.dta, replace clear

log close
