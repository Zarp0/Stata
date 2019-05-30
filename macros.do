*Macro that assigns variable labels
	foreach x of varlist * {
	   label var `x' `"`=`x'[1]'"'
		}
	drop in 1
	foreach x of varlist * {
	   cap destring `x', replace
		}
	desc  

*Macro that converts all responses to numeric (new numeric variables created with an _n appended (eg, x to x_n))
				capture drop *_n*
				capture drop *_temp
				local alias *insert variables*
				foreach j of varlist `alias' {
						 split `j', gen(`j'_n) parse(" ") destring
					   rename `j'_n1 `j'_temp
					   capture  drop `j'_n*
						  rename `j'_temp `j'_n
								}
