%let pgm=utl-altair-personal-scl-Monarch-Exercise-38-UKG-Pro-Detail-Labor-Allocations-by-Project;

%stop_submission;

Altair personal scl Monarch Exercise 38 UKG Pro Detail Labor Allocations by Project

Too long to pose in a listserve, see github

github
https://github.com/rogerjdeangelis/utl-altair-personal-scl-Monarch-Exercise-38-UKG-Pro-Detail-Labor-Allocations-by-Project

https://community.altair.com/discussion/34153
https://community.altair.com/discussion/34153/monarch-exercise-38-ukg-pro-detail-labor-allocations-by-project#latest

 CONTENTS AND RESULTS

 1  EXTRACT DATA FROM EXCEL

    Create Tables
      companys (eight company names
      combined (all eight sheets combined)


 2  TOTAL TAXES BY PROJECT FOR THE COMPANY?

                     PROJ_COMPANY                            EMPLOYEE_TAX

    Project:  10100000        - Corporate                       9961.95
    Project:  12000000        - Marketing                       2109.70
    Project:  17000000        - The Center                      1175.77
    Project:  27027080        - Kresge Found. - Next Gen.        534.90
    Project:  27036060        - United Way AIMS CCF             2009.65
    Project:  27067060        - YAP Wayne County                 816.97
    Project:  27095985        - City of Detroit NOF              184.93


 3  WHICH EMPLOYEE HAD THE LARGEST NUMBER OFDEDUCTIONS?

    NAMESAV

    y2xxxxx, Jesse H


 4  WHICH EMPLOYEE HAD THE LARGEST NET PAY?

             NAME               NET_PAY

       y11xxxxx, Vincent        4167.83

NOTES:

Was unable to use the sas libname excel engine, could noy figure out how to startr reading excel at row 5.

This is a very poor excel detail invoice design.

Having the same exact category name have four different meanings, makes this very difficult
to analyze programatically. Also having multiple exact duplicates without a primary key does
not allow joining global and local tables. Time might be better spent designing a format for
detail invoices that excel can easily analyze.

I removed exact duplicate sheets


/*             _                  _         _       _                           _
/ |   _____  _| |_ _ __ __ _  ___| |_    __| | __ _| |_ __ _   _____  _____ ___| |
| |  / _ \ \/ / __| `__/ _` |/ __| __|  / _` |/ _` | __/ _` | / _ \ \/ / __/ _ \ |
| | |  __/>  <| |_| | | (_| | (__| |_  | (_| | (_| | || (_| ||  __/>  < (_|  __/ |
|_|  \___/_/\_\\__|_|  \__,_|\___|\__|  \__,_|\__,_|\__\__,_| \___/_/\_\___\___|_|
*/

proc datasets lib=work nodetails nolist;
 delete combined companys;
run;quit;

&_init_;
proc r;
submit;
library(readxl)
library(purrr)
library(dplyr)

# GET EMPLOYEES

read_three_sheets <- function(file_path, sheets = 1:7) {
  sheet_names <- excel_sheets(file_path)  # get all sheet names
  selected_names <- sheet_names[sheets]

  dfs <- map2(sheets, selected_names, ~ {
    df <- read_excel(file_path, sheet = .x, skip = 4)
    df <- mutate(df, SheetName = .y)  # add sheet name as a new column
    df
  })

  names(dfs) <- selected_names
  dfs
}

# CALL FUNCTION

file <- "d:/xls/Detail Labor Allocations by Project.xlsx"
result_list <- read_three_sheets(file)

head(result_list[[1]])
combined <- bind_rows(result_list, .id = "SourceSheet")

# GET COMPANIES

sheets <- excel_sheets(file)[1:7]
cells <- lapply(sheets, function(s) {
  read_excel(file, sheet = s, range = "A4", col_names = FALSE)[[1]]
})
names(cells) <- sheets

result <- data.frame(sheet = factor(names(cells), levels = sheets),
                     value = unlist(cells))
*result <- result[order(result$sheet), ]

endsubmit;
import data=combined r=combined;
import data=companys r=result;
run;quit;

proc print data=combined(obs=10);
run;quit;

proc print data=companys;
run;quit;


WORK,COMPANYS

Obs        SHEET                                 VALUE

 1     XYZ19,10100000    Project:  10100000        - Corporate
 2     XYZ19,12000000    Project:  12000000        - Marketing
 3     XYZ19,17000000    Project:  17000000        - The Center
 4     XYZ19,27027080    Project:  27027080        - Kresge Found. - Next Gen.
 5     XYZ19,27036060    Project:  27036060        - United Way AIMS CCF
 6     XYZ19,27067060    Project:  27067060        - YAP Wayne County
 7     XYZ19,27095985    Project:  27095985        - City of Detroit NOF


WORk.COMBINED

Obs     SOURCESHEET           NAME          EMP_NO     CATEGORY     CODE     HOURS    EE_AMOUNT    ER_AMOUNT    NET_PAY

  1    XYZ19,10100000    y1xxxxx, Salina    084285    Earnings      GTL         0         2.44         0        1063.26
  2    XYZ19,10100000                                               REG        76      1596.00         0            0
  3    XYZ19,10100000                                 Earnings                 76      1598.44         0            0
  4    XYZ19,10100000                                 Deductions    403BF       0        52.26         0            0
  5    XYZ19,10100000                                               AFCAD       0         0.72         0            0
  6    XYZ19,10100000                                               AFCE1       0         2.88         0            0
  7    XYZ19,10100000                                               AFHO1       0        10.69         0            0
  8    XYZ19,10100000                                               DDPPO       0         9.69        9.30          0
  9    XYZ19,10100000                                               GLIFE       0          0          5.51          0
 10    XYZ19,10100000                                               GTL         0         2.44         0            0
....
....

/*
| | ___   __ _
| |/ _ \ / _` |
| | (_) | (_| |
|_|\___/ \__, |
         |___/
*/

5426
5427      proc datasets lib=work nodetails nolist;
5428       delete combined companys;
5429      run;quit;
NOTE: Deleting "WORK.COMBINED" (memtype="DATA")
NOTE: Deleting "WORK.COMPANYS" (memtype="DATA")
NOTE: Procedure datasets step took :
      real time       : 0.001
      user cpu time   : 0.000
      system cpu time : 0.000
      Timestamp       :   20OCT25:14:36:14
      Peak working set    : 91176k
      Current working set : 49544k
      Page fault count    : 0


5430
5431      &_init_;
5432      proc r;
5433      submit;
5434      library(readxl)
5435      library(purrr)
5436      library(dplyr)
5437
5438      # GET EMPLOYEES
5439
5440      read_three_sheets <- function(file_path, sheets = 1:7) {
5441        sheet_names <- excel_sheets(file_path)  # get all sheet names
5442        selected_names <- sheet_names[sheets]
5443
5444        dfs <- map2(sheets, selected_names, ~ {
5445          df <- read_excel(file_path, sheet = .x, skip = 4)
5446          df <- mutate(df, SheetName = .y)  # add sheet name as a new column
5447          df
5448        })
5449
5450        names(dfs) <- selected_names
5451        dfs
5452      }
5453
5454      # CALL FUNCTION
5455
5456      file <- "d:/xls/Detail Labor Allocations by Project.xlsx"
5457      result_list <- read_three_sheets(file)
5458
5459      head(result_list[[1]])
5460      combined <- bind_rows(result_list, .id = "SourceSheet")
5461
5462      # GET COMPANIES
5463
5464      sheets <- excel_sheets(file)[1:7]
5465      cells <- lapply(sheets, function(s) {
5466        read_excel(file, sheet = s, range = "A4", col_names = FALSE)[[1]]
5467      })
5468      names(cells) <- sheets
5469
5470      result <- data.frame(sheet = factor(names(cells), levels = sheets),
5471                           value = unlist(cells))
5472      *result <- result[order(result$sheet), ]
5473
5474      endsubmit;
NOTE: Using R version 4.5.1 (2025-06-13 ucrt) from d:\r451

NOTE: Submitting statements to R:

> library(readxl)
> library(purrr)
Attaching package: 'dplyr'
The following objects are masked from 'package:stats':
    filter, lag
The following objects are masked from 'package:base':
    intersect, setdiff, setequal, union
> library(dplyr)
>
> # GET EMPLOYEES
>
> read_three_sheets <- function(file_path, sheets = 1:7) {
+   sheet_names <- excel_sheets(file_path)  # get all sheet names
+   selected_names <- sheet_names[sheets]
+
+   dfs <- map2(sheets, selected_names, ~ {
+     df <- read_excel(file_path, sheet = .x, skip = 4)
+     df <- mutate(df, SheetName = .y)  # add sheet name as a new column
+     df
+   })
+
+   names(dfs) <- selected_names
+   dfs
+ }
>
> # CALL FUNCTION
>
> file <- "d:/xls/Detail Labor Allocations by Project.xlsx"
Warning messages:
1: Expecting numeric in G515 / R515C7: got a date
2: Expecting numeric in G164 / R164C7: got a date
3: Expecting numeric in G185 / R185C7: got a date
4: Expecting numeric in G46 / R46C7: got a date
5: Expecting numeric in G137 / R137C7: got a date
6: Expecting numeric in G169 / R169C7: got a date
7: Expecting numeric in G42 / R42C7: got a date
> result_list <- read_three_sheets(file)
>
> head(result_list[[1]])
> combined <- bind_rows(result_list, .id = "SourceSheet")
>
> # GET COMPANIES
>
> sheets <- excel_sheets(file)[1:7]
> cells <- lapply(sheets, function(s) {
+   read_excel(file, sheet = s, range = "A4", col_names = FALSE)[[1]]
New names:
* `` -> `...1`
New names:
* `` -> `...1`
New names:
* `` -> `...1`
New names:
* `` -> `...1`
New names:
* `` -> `...1`
New names:
* `` -> `...1`
New names:
* `` -> `...1`
+ })
> names(cells) <- sheets
>
> result <- data.frame(sheet = factor(names(cells), levels = sheets),
+                      value = unlist(cells))
Error: unexpected '*' in "*"
> *result <- result[order(result$sheet), ]

NOTE: Processing of R statements complete

>
5475      import data=combined r=combined;
NOTE: Creating data set 'WORK.combined' from R data frame 'combined'
NOTE: Column names modified during import of 'combined'
NOTE: Data set "WORK.combined" has 1223 observation(s) and 10 variable(s)

5476      import data=companys r=result;
NOTE: Creating data set 'WORK.companys' from R data frame 'result'
NOTE: Column names modified during import of 'result'
NOTE: Data set "WORK.companys" has 7 observation(s) and 2 variable(s)

5477      run;quit;
NOTE: Procedure r step took :
      real time       : 1.985
      user cpu time   : 0.000
      system cpu time : 0.000
      Timestamp       :   20OCT25:14:36:16
      Peak working set    : 91176k
      Current working set : 49544k
      Page fault count    : 4


5478
5479      proc print data=combined(obs=10);
5480      run;quit;
NOTE: 10 observations were read from "WORK.combined"
NOTE: Procedure print step took :
      real time       : 0.004
      user cpu time   : 0.000
      system cpu time : 0.000
      Timestamp       :   20OCT25:14:36:16
      Peak working set    : 91176k
      Current working set : 49544k
      Page fault count    : 2


5481
5482      proc print data=companys;
5483      run;quit;
NOTE: 7 observations were read from "WORK.companys"
NOTE: Procedure print step took :
      real time       : 0.004
      user cpu time   : 0.000
      system cpu time : 0.000
      Timestamp       :   20OCT25:14:36:16
      Peak working set    : 91176k
      Current working set : 49544k
      Page fault count    : 2

/*___   _                              _        _           _
|___ \ | |_ __ ___  _____  ___   _ __ | |_ ___ (_) ___  ___| |_   ___ ___  _ __ ___  _ __   __ _ _ __  _   _
  __) || __/ _` \ \/ / _ \/ __| | `_ \| __/ _ \| |/ _ \/ __| __| / __/ _ \| `_ ` _ \| `_ \ / _` | `_ \| | | |
 / __/ | || (_| |>  <  __/\__ \ | |_) | || (_) | |  __/ (__| |_ | (_| (_) | | | | | | |_) | (_| | | | | |_| |
|_____| \__\__,_/_/\_\___||___/ | .__/ \__\___// |\___|\___|\__| \___\___/|_| |_| |_| .__/ \__,_|_| |_|\__, |
                                |_|          |__/                                   |_|                |___/
*/

proc datasets lib=work nolist nodetails;
 delete addcompany;
run;quit;

/*--- add company to combined sheets ---*/
proc sql;
  create
     table addcompany as
  select
     r.value as proj_company
    ,sum(l.ee_amount)  as employee_tax
  from
    combined as l left join companys as r
  on
    l.sourcesheet eqt r.sheet
  where
    l.category='Taxes' and l.er_amount>0
  group
    by r.value
;quit;

proc print data=addcompany;
run;quit;


OUTPUT WORK.ADDCOMPANY
----------------------

Obs                        PROJ_COMPANY                         EMPLOYEE_TAX

 1     Project:  10100000        - Corporate                       9961.95
 2     Project:  12000000        - Marketing                       2109.70
 3     Project:  17000000        - The Center                      1175.77
 4     Project:  27027080        - Kresge Found. - Next Gen.        534.90
 5     Project:  27036060        - United Way AIMS CCF             2009.65
 6     Project:  27067060        - YAP Wayne County                 816.97
 7     Project:  27095985        - City of Detroit NOF              184.93

/*
| | ___   __ _
| |/ _ \ / _` |
| | (_) | (_| |
|_|\___/ \__, |
         |___/
*/

5572
5573      proc datasets lib=work nolist nodetails;
5574       delete addcompany;
5575      run;quit;
NOTE: Deleting "WORK.ADDCOMPANY" (memtype="DATA")
NOTE: Procedure datasets step took :
      real time       : 0.001
      user cpu time   : 0.000
      system cpu time : 0.000
      Timestamp       :   20OCT25:14:42:44
      Peak working set    : 91176k
      Current working set : 49572k
      Page fault count    : 0


5576
5577      /*--- add company to combined sheets ---*/
5578      proc sql;
5579        create
5580           table addcompany as
5581        select
5582           r.value as proj_company
5583          ,sum(l.ee_amount)  as employee_tax
5584        from
5585          combined as l left join companys as r
5586        on
5587          l.sourcesheet eqt r.sheet
5588        where
5589          l.category='Taxes' and l.er_amount>0
5590        group
5591          by r.value
5592      ;quit;
NOTE: Data set "WORK.addcompany" has 7 observation(s) and 2 variable(s)
NOTE: Procedure sql step took :
      real time       : 0.059
      user cpu time   : 0.015
      system cpu time : 0.015
      Timestamp       :   20OCT25:14:42:44
      Peak working set    : 91176k
      Current working set : 49576k
      Page fault count    : 181


5593
5594      proc print data=addcompany;
5595      run;quit;
NOTE: 7 observations were read from "WORK.addcompany"
NOTE: Procedure print step took :
      real time       : 0.027
      user cpu time   : 0.000
      system cpu time : 0.031
      Timestamp       :   20OCT25:14:42:44
      Peak working set    : 91176k
      Current working set : 49576k
      Page fault count    : 2

/*____                              _          _            _   _                        _
|___ /   _ __ ___   __ ___  __   __| | ___  __| |_   _  ___| |_(_) ___  _ __   ___ _ __ | |_
  |_ \  | `_ ` _ \ / _` \ \/ /  / _` |/ _ \/ _` | | | |/ __| __| |/ _ \| `_ \ / __| `_ \| __|
 ___) | | | | | | | (_| |>  <  | (_| |  __/ (_| | |_| | (__| |_| | (_) | | | | (__| | | | |_
|____/  |_| |_| |_|\__,_/_/\_\  \__,_|\___|\__,_|\__,_|\___|\__|_|\___/|_| |_|\___|_| |_|\__|
*/

proc datasets lib=work nolist nodetails;
 delete rolldeduct;
run;quit;

data rolldeduct;
 retain flg cnt 0 namesav categorysav;
 set combined;
 if not missing(name) then namesav=name;
 if category='Earnings' then categorysav="Earnings";
 *if namesav='y2xxxxx, Alexa';
 if categorysav = 'Earnings' and missing(code) then do; flg=1; ct=0;end;
 if flg=1 and not missing(code) then cnt=cnt+1;
 if category='Taxes' and missing(code) then do;output;categorysav=category; cnt=0;flg=0;end;
 keep namesav code category categorysav flg cnt;
run;quit;

proc print data=rolldeduct;
run;quit;
proc sql;
  create
     table deduct_max as
  select
     namesav
    ,cnt as deduct_max
  from
    rolldeduct
  having
    max(cnt) = cnt
;quit;

proc print data=deduct_max;
run;quit;


OUTPUT WORK.DEDUCT_MAX
----------------------

Obs         NAMESAV         DEDUCT_MAX

 1     y2xxxxx, Jesse H.        26

/*
| | ___   __ _
| |/ _ \ / _` |
| | (_) | (_| |
|_|\___/ \__, |
         |___/
*/

5572
5573      proc datasets lib=work nolist nodetails;
5574       delete addcompany;
5575      run;quit;
NOTE: Deleting "WORK.ADDCOMPANY" (memtype="DATA")
NOTE: Procedure datasets step took :
      real time       : 0.001
      user cpu time   : 0.000
      system cpu time : 0.000
      Timestamp       :   20OCT25:14:42:44
      Peak working set    : 91176k
      Current working set : 49572k
      Page fault count    : 0

5576
5577      /*--- add company to combined sheets ---*/
5578      proc sql;
5579        create
5580           table addcompany as
5581        select
5582           r.value as proj_company
5583          ,sum(l.ee_amount)  as employee_tax
5584        from
5585          combined as l left join companys as r
5586        on
5587          l.sourcesheet eqt r.sheet
5588        where
5589          l.category='Taxes' and l.er_amount>0
5590        group
5591          by r.value
5592      ;quit;
NOTE: Data set "WORK.addcompany" has 7 observation(s) and 2 variable(s)
NOTE: Procedure sql step took :
      real time       : 0.059
      user cpu time   : 0.015
      system cpu time : 0.015
      Timestamp       :   20OCT25:14:42:44
      Peak working set    : 91176k
      Current working set : 49576k
      Page fault count    : 181


5593
5594      proc print data=addcompany;
5595      run;quit;
NOTE: 7 observations were read from "WORK.addcompany"
NOTE: Procedure print step took :
      real time       : 0.027
      user cpu time   : 0.000
      system cpu time : 0.031
      Timestamp       :   20OCT25:14:42:44
      Peak working set    : 91176k
      Current working set : 49576k
      Page fault count    : 2


/*  _     _                           _                _
| || |   | | __ _ _ __ __ _  ___  ___| |_   _ __   ___| |_ _ __   __ _ _   _
| || |_  | |/ _` | `__/ _` |/ _ \/ __| __| | `_ \ / _ \ __| `_ \ / _` | | | |
|__   _| | | (_| | | | (_| |  __/\__ \ |_  | | | |  __/ |_| |_) | (_| | |_| |
   |_|   |_|\__,_|_|  \__, |\___||___/\__| |_| |_|\___|\__| .__/ \__,_|\__, |
                      |___/                               |_|          |___/
*/

proc datasets lib=work nolist nodetails;
 delete netpay;
run;quit;

proc sql;
  create
     table netpay_max as
  select
     name
    ,net_pay
  from
     combined
  having
     max(net_pay) = net_pay and name eqt 'y'
;quit;

proc print data=netpay_max;
run;quit;

OUTPUT WORK.NETPAY
------------------

Obs          NAME           NET_PAY

 1     y11xxxxx, Vincent    4167.83

/*
| | ___   __ _
| |/ _ \ / _` |
| | (_) | (_| |
|_|\___/ \__, |
         |___/
*/

5572
5573      proc datasets lib=work nolist nodetails;
5574       delete addcompany;
5575      run;quit;
NOTE: Deleting "WORK.ADDCOMPANY" (memtype="DATA")
NOTE: Procedure datasets step took :
      real time       : 0.001
      user cpu time   : 0.000
      system cpu time : 0.000
      Timestamp       :   20OCT25:14:42:44
      Peak working set    : 91176k
      Current working set : 49572k
      Page fault count    : 0


5576
5577      /*--- add company to combined sheets ---*/
5578      proc sql;
5579        create
5580           table addcompany as
5581        select
5582           r.value as proj_company
5583          ,sum(l.ee_amount)  as employee_tax
5584        from
5585          combined as l left join companys as r
5586        on
5587          l.sourcesheet eqt r.sheet
5588        where
5589          l.category='Taxes' and l.er_amount>0
5590        group
5591          by r.value
5592      ;quit;
NOTE: Data set "WORK.addcompany" has 7 observation(s) and 2 variable(s)
NOTE: Procedure sql step took :
      real time       : 0.059
      user cpu time   : 0.015
      system cpu time : 0.015
      Timestamp       :   20OCT25:14:42:44
      Peak working set    : 91176k
      Current working set : 49576k
      Page fault count    : 181


5593
5594      proc print data=addcompany;
5595      run;quit;
NOTE: 7 observations were read from "WORK.addcompany"
NOTE: Procedure print step took :
      real time       : 0.027
      user cpu time   : 0.000
      system cpu time : 0.031
      Timestamp       :   20OCT25:14:42:44
      Peak working set    : 91176k
      Current working set : 49576k
      Page fault count    : 2

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
