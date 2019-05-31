clear all
use "P:\\Mental_Health_Integrated\v2_20102014\Data\analysis.dta"    
***CREATE VARIABLES***
*Care model-integrated versus usual
capture label drop integratedlab
label define integratedlab 0 "Usual Care" 1 "Integrated Care"
label value achc_ind integratedlab
tab achc_ind

tabstat sd_age_cohent_val, by(achc_ind) statistics (n mean sd min p25 p50 p75 max)
*general age - <45, 45-64, 65+
capture drop age_cat
generate age_cat = sd_age_cohent_val
recode age_cat(min/44 =1)(45/64 =2) (65/max =3)
capture label drop age_catlab
label define age_catlab 1 "<45" 2 "45-64" 3 "65+"
label value age_cat age_catlab
tab age_cat achc_ind, chi2
tabstat sd_age_measmt_val, by(achc_ind) statistics (n mean sd min p25 p50 p75 max)
*screening_age
capture drop screening_age
generate screening_age = sd_age_measmt_val
recode screening_age(min/29 =1)(30/49 =2) (50/64 =3) (65/max =4)
capture label drop screening_agelab
label define screening_agelab 1 "18-29" 2 "30-49" 3 "50-64" 4 "65+" 
label value screening_age screening_agelab
tab screening_age achc_ind, chi2

*Age - Breast Cancer
capture drop age_bc
generate age_bc = sd_age_measmt_val
recode age_bc (min/49 =0)(50/59 =1) (60/64 =2) (65/max =3)
capture label drop age_bclab
label define age_bclab 0 "18-49" 1 "50-59" 2 "60-64" 3 "65+" 
label value age_bc age_bclab
tab age_bc achc_ind, chi2

*Age - Cervical Cancer
capture drop age_cvc
generate age_cvc = sd_age_measmt_val
recode age_cvc (min/20 =0)(21/29 =1)(30/59 =2) (60/max =3)
capture label drop age_cvclab
label define age_cvclab 0 "18-20" 1 "21-29" 2 "30-59" 3 "60+"
label value age_cvc age_cvclab
tab age_cvc achc_ind, chi2

*Age - Colorectal Cancer
capture drop age_crc
generate age_crc = sd_age_measmt_val
recode age_crc (min/49 =0)(50/59 =1)(60/64 =2) (60/64 =3) (65/max =4)
capture label drop age_crclab
label define age_crclab 1 "18-49" 2 "30-49" 3 "50-64" 4 "65+" 
label value age_crc age_crclab
tab age_crc achc_ind, chi2

*marital status
*1: Single, 2: Married, 3: Separated, 4: Divorced, 5: Widowed, 6: Unknown, 7: Partner
capture drop maritalstatus
generate maritalstatus = sd_marital_status_cd
recode maritalstatus (2=1) (1=0) (3=0) (4=0) (5=0) (6=0) (7=0)
capture label drop maritalstatuslab
label define maritalstatuslab 1 "Married" 0 "Other" 
label value maritalstatus maritalstatuslab
tab maritalstatus achc_ind, chi2

*Insurance Status
*0: Medicaid/BadgerCare, 1: Medicare, 2: Commercial, 4: Unknown
*no coding for uninsured
capture drop insurancestatus
generate insurancestatus = sd_payor_type_study_4cat_cd
recode insurancestatus (0=0) (1=0) (2=1) (3=2)
capture label drop insurancestatuslab
label define insurancestatuslab 0 "Medicare/Medicaid" 1 "Private" 2 "Unknown"
label value insurancestatus insurancestatuslab
tab insurancestatus achc_ind, chi2

*race/ethnicities
*0: Unknown, 1: White, 2: Black, 3: Native Hawaiian, Pacific Islander, Multiracial, 4: Asian, 5: Hispanic/Latino, 6: American Indian/Alaska Native
capture drop racialethnic
generate racialethnic = sd_race_ethnicity_cd
recode racialethnic (0=0) (1=1) (2=2) (3=4) (4=4) (5=3) (6=4)
capture label drop racialethniclab
label define racialethniclab 0 "Unknown" 1 "White" 2 "Black" 3 "Hispanic or Latino" 4 "Other"
label value racialethnic racialethniclab
tab racialethnic achc_ind, chi2
*language
capture drop language
generate language=sd_language_2cat_cd
label define languagelab 1 "English" 2 "Non-English"
label value language languagelab
tab language achc_ind, chi2

*comorbidity
capture drop elix_count_2cat
gen elix_count_2cat=c_elix_bf_coh_cnt
recode elix_count_2cat (0=0) (1/11=1)
tab elix_count_2cat achc_ind, chi2

*Aim 2

*screening ages
*Age - Breast Cancer
capture drop age_bc
generate age_bc = sd_age_measmt_val
recode age_bc (min/49 =0)(50/59 =1) (60/64 =2) (65/max =3)
capture label drop age_bclab
label define age_bclab 0 "18-49" 1 "50-59" 2 "60-64" 3 "65+" 
label value age_bc age_bclab
tab age_bc achc_ind, chi2

*Age - Cervical Cancer
capture drop age_cvc
generate age_cvc = sd_age_measmt_val
recode age_cvc (min/20 =0)(21/29 =1)(30/59 =2) (60/max =3)
capture label drop age_cvclab
label define age_cvclab 0 "18-20" 1 "21-29" 2 "30-59" 3 "60+"
label value age_cvc age_cvclab
tab age_cvc achc_ind, chi2

*Age - Colorectal Cancer
capture drop age_crc
generate age_crc = sd_age_measmt_val
recode age_crc (min/49 =0)(50/59 =1)(60/64 =2) (60/64 =3) (65/max =4)
capture label drop age_crclab
label define age_crclab 1 "18-49" 2 "30-49" 3 "50-64" 4 "65+" 
label value age_crc age_crclab
tab age_crc achc_ind, chi2

*Breast cancer screening count
capture drop bcs_count bcs_count2 bcs_realcount
bysort hip_patient_id bcs_last_screening_dt: gen bcs_count = _n if bcs_last_screening_dt !=.
generate bcs_count2 = bcs_count if bcs_count == 1
bysort hip_patient_id: egen bcs_realcount = sum(bcs_count2)
replace bcs_realcount = . if sd_age_measmt_val <= 40
replace bcs_realcount = . if sd_female_ind == 0
replace bcs_realcount = . if bcs_count2 = .
*Colon cancer screening count
capture drop crc_count crc_count2 crc_realcount
bysort hip_patient_id crc_last_screening_dt: gen crc_count = _n if crc_last_screening_dt !=.
generate crc_count2 = crc_count if crc_count == 1
bysort hip_patient_id: egen crc_realcount = sum(crc_count2)
replace crc_realcount = . if sd_age_measmt_val <= 50
*Cervical cancer screening count
capture drop cvc_count cvc_count2 cvc_realcount
bysort hip_patient_id cvc_last_screening_dt: gen cvc_count = _n if cvc_last_screening_dt !=.
generate cvc_count2 = cvc_count if cvc_count == 1
bysort hip_patient_id: egen cvc_realcount = sum(cvc_count2)
replace cvc_realcount = . if sd_age_measmt_val <= 21
replace cvc_realcount = . if sd_age_measmt_val >= 64
replace cvc_realcount = . if sd_female_ind == 0
tab cvc_realcount age_cvc

tab bcs_realcount achc_ind, chi2
  tab crc_realcount achc_ind, chi2
tab cvc_realcount achc_ind, chi2
*create enrollment time variable and collapse into patient level
bysort hip_patient_id: gen id = _n
bysort hip_patient_id: egen enrollment = max(id)
drop if id>1
*demographics indicators
capture drop cvc_ind
generate cvc_ind = 1 if cvc_realcount >=1 
generate crc_ind = 1 if crc_realcount >=1 
generate bc_ind = 1 if bcs_realcount >=1 

*
tabulate age_cvc achc_ind if cvc_ind == 1, chi2
tabulate maritalstatus achc_ind if cvc_ind == 1, chi2
tabulate insurancestatus achc_ind if cvc_ind == 1, chi2
tabulate racialethnic achc_ind if cvc_ind == 1, chi2

tabulate age_crc achc_ind if crc_ind == 1, chi2
tabulate maritalstatus achc_ind if crc_ind == 1, chi2
tabulate insurancestatus achc_ind if crc_ind == 1, chi2
tabulate racialethnic achc_ind if crc_ind == 1, chi2

tabulate age_bc achc_ind if bc_ind == 1, chi2
tabulate maritalstatus achc_ind if bc_ind == 1, chi2
tabulate insurancestatus achc_ind if bc_ind == 1, chi2
tabulate racialethnic achc_ind if bc_ind == 1, chi2

*ANALYSIS

logistic cvc_ind $cov10, vce (cluster patient_id)
logistic crc_ind $cov10, vce (cluster patient_id)
logistic bc_ind $cov10, vce (cluster patient_id)
