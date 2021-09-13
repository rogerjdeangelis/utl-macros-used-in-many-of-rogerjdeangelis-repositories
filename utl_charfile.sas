%let pgm=Utl_CHARFILE;
/******************************************************************************************************/
/*  Program: SAS Data Set Characterization Utility.sas                                                */
/*                                                                                                    */
/*  Author: Michael A. Raithel based on a program and GREAT IDEA by: Bob McConnaughey                 */
/*                                                                                                    */
/*  Created: 5/1/2020                                                                                 */
/*                                                                                                    */
/*  Purpose: This SAS program creates a report of detailed variable-level information for a specific  */
/*           SAS data set, including counts of non-missing and missing values; and min, max, mean,    */
/*           and std for numeric variables.                                                           */
/*                                                                                                    */
/*  Parameters: Users must specify the following three parameters:                                    */
/*                                                                                                    */
/*             DIRNAME    - The directory holding the SAS data set that is to be characterized.       */
/*             DSNAME     - The name of the SAS data set to be characterized.                         */
/*             REPTDIR    - The directory where the report will be written.                           */
/*                                                                                                    */
/*  Outputs: This program creates a Excel spreadsheet with the same name as the SAS data set with     */
/*           the words "Data Set Characterization Report <DATE REPORT WAS CREATED>" appended to it.   */
/*                                                                                                    */
/*  Change Log:                                                                                       */
/*                                                                                                    */
/*         12/15/20 - MAR - Consolidated missing value computation for character variables in Part 3. */
/*                                                                                                    */
/******************************************************************************************************/

%MACRO Utl_CHARFILE(DIRNAME=, DSNAME=, REPTDIR=);

options symbolgen mprint mlogic source2 orientation=landscape nodate nonumber;

libname sasdata "&DIRNAME" access=readonly;

***********************************************************************;
* PART 1 - Use PROC CONTENTS to get basic variable information        *;
***********************************************************************;

/* PROC CONTENTS to get variable attributes */
proc contents data=sasdata.&DSNAME noprint
          out=Contents_Vars(keep=name label type length format varnum);
run;

/* Create Vtype variable */
data Contents_Vars;
set  Contents_Vars;

drop type;

if type = 1 then Vtype = "Num ";
       else if type = 2 then Vtype = "Char";

run;

/* Sort for future match-merge */
proc sort data=Contents_Vars;
       by Name;
run;

*************************************************************************************;
* PART 2 - Access VTABLE to determine the number of character and numeric variables.*;
*          Store them in macro variables which will then be used to determine which *;
*          subsequent sections of the program are executed.                         *;
*************************************************************************************;
data _null_;
set  sashelp.vtable(where=(libname = "SASDATA" and memname = upcase("&DSNAME") and memtype = "DATA"));

call symput("CHARCOUNT", num_character);

call symput("NUMCOUNT",num_numeric);

run;

***********************************************************************************;
* PART 3 - If &NUMCOUNT NE 0 then the data set has numeric variables that are     *;
*          processed in this part.                                                *;
*          If &CHARCOUNT NE 0 then the data set has character variables that are  *;
*          processed in this part.                                                *;
***********************************************************************************;

       /******************************************************/
       /* ONLY DO THIS SECTION IF THERE ARE NUMERIC VARIABLES*/
       /******************************************************/

%IF &NUMCOUNT NE 0 %THEN %DO;

       /* Execute PROC MEANS against data set of interest to get stats of interest */
       proc means data = sasdata.&DSNAME maxdec = 2 noprint;
       output out=MeansOutput;
       run;

       /* Transpose to linearize the data and get variables in the desired order */
       proc transpose data=MeansOutput out=MeansTranspose;
       run;

       /* Create variables we want and drop superfluous observations */
       Data NumericVars(keep= Name NonMissing NumMissingValues Min Max Mean STD);
       retain Name NonMissing NumMissingValues Min Max Mean STD;
       set  MeansTranspose;

       length Name $32.;

       retain TotalObs;

       if _NAME_ = "_TYPE_" then delete;

       if _NAME_ = "_FREQ_ " then do;
              TotalOBs = COL1;
              delete;
       end;

       Name       = _NAME_;
       NonMissing = COL1;
       Min        = COL2;
       Max        = COL3;
       Mean       = COL4;
       STD        = COL5;

       NumMissingValues = TotalObs - COL1;

       run;

       /* Sort for future match-merge */
       proc sort data=NumericVars;
              by Name;
       run;

%END;

       /********************************************************/
       /* ONLY DO THIS SECTION IF THERE ARE CHARACTER VARIABLES*/
       /********************************************************/

%IF &CHARCOUNT NE 0 %THEN %DO;

       /* Determine missing values for character variables */
       data CharacterVars;
       set sasdata.&DSNAME end = eof;

       length Name $32.;

       keep Name NonMissing NumMissingValues;

       array charvars[*] _character_;
       array missing_count[&CHARCOUNT] _temporary_;

       do i = 1 to &CHARCOUNT;
              if missing(charvars[i]) then missing_count[i] + 1;
       end;

       if eof then do;
              do J = 1 to &CHARCOUNT;
                Name = vname(charvars[J]);
                NumMissingValues = missing_count[J];
                      if NumMissingValues = . then NumMissingValues = 0;
                      NonMissing = _N_ - NumMissingValues;
                output;
             end;
       end;

       run;

       /* Sort for future match-merge */
       proc sort data=CharacterVars;
              by Name;
       run;

%END;

***********************************************************************************;
* PART 4 - Merge previously created data sets together with Contents_Vars.        *;
*                                                                                 *;
*          The first &If/&DO/&END block addresses numeric variables if they exist.*;
*          Once the numeric variables are merged, it checks whether character     *;
*          variables exist. If so, they are merged too.                           *;
*                                                                                 *;
*          The second &If/&DO/&END block is ONLY executed if NO numeric variables *;
*          exist. It processes the character variables in the SAS data set.       *;
***********************************************************************************;

       /****************************************************************************/
       /* This section is executed if there are NUMERIC variables in the data set  */
       /****************************************************************************/

%IF &NUMCOUNT NE 0 %THEN %DO;  /* BEGIN block for when there are numeric variables */

       /* Merge numeric variable data with metadata for each variable */
       data FinalMetaData;
       retain Name Label Vtype Length Varnum NonMissing NumMissingValues Min Max Mean STD;
       merge NumericVars Contents_Vars;
              by Name;
       run;

       %IF &CHARCOUNT NE 0 %THEN %DO; /* BEGIN block for when there are BOTH character and numeric variables */

              /* Merge in character data to get character variable missing value counts */
              data FinalMetaData;
              merge FinalMetaData CharacterVars;
                     by Name;
              run;

       %END; /* END block for when there are BOTH character and numeric variables */

%END;    /* END block for when there are numeric variables */

       /**********************************************************************************/
       /* This section is executed if there are ONLY CHARACTER variables in the data set */
       /**********************************************************************************/

%ELSE %DO;

       /* Merge character data with metadata to get character variable missing value counts */
       data FinalMetaData;
       retain Name Label Vtype Length Varnum NonMissing NumMissingValues;
       merge Contents_Vars CharacterVars;
              by Name;
       run;

%END;

****************************************************************************;
* PART 5 - Create the report file                                          *;
****************************************************************************;

ODS EXCEL file="&REPTDIR\&DSNAME Data Set Characterization Report &SYSDATE..xlsx";

ods EXCEL options(sheet_name="SAS Data Set Characteristics");

proc print noobs data=FinalMetaData label;
label  vtype = "Variable Type"
              NonMissing     = "Non-Missing Values"
              NumMissingValues = "Missing Values"
              ;

%IF &NUMCOUNT NE 0 %THEN %DO; /* Not executed if there are no NUMERIC variables*/

       label STD   = "Standard Deviation";

       format min max mean std 10.2 ;

%END;

run;

ODS Excel close;

%MEND utl_CHARFILE;


%*CHARFILE(DIRNAME=d:/jhu, DSNAME=jhu_100cor20200830confirmus, REPTDIR=d:/jhu/xls);
