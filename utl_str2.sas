********************************************************************;
********** SAS Macro %str(): Display the Structure of a SAS dataset;
**********                   Similar to R function utils:::str(object) that 
**********                   Compactly Displays the Structure of an R Object;
********** DBIN:    Input Dataset;
********** DDTOUT:  If Y then output of a Data Definition Table in SAS Output Window;
**********          If N (default): output in SAS log only;
********** Additional Feature: Numeric variables will be parsed whether they are 'interger'
**********                     or 'float' (number of decimal places / display format will be identified);
********** Additional Feature: Character variables will be parsed to derive the (real) length
**********                     maximum length of the character values based on actual values; 
********** Limitation: Character variables in database may not be longer then <= 400 characters 
**********             (performance issue, can be changed);
**********             Does not work correct in case of truncated formats, e.g., $SEX. "F"="Female" is 
**********             formated as $SEX4. and will be truncated to "Fema" (4 characters);
**********             SAS v. 9.4 above required;
********** Example: %str2(DM, DDTOUT=Y);

********** NOTE: If you use character variables with a length > 400 char. then change twice 
********** within the Macro: ValFormat=$400. to ValFormat=$[YourMaxlength];

*%include "gather2.sas"; * Macro gather2() necessary - will be invoked;
*%str2(DM);

%macro utl_str2(DBIN, DDTOUT=N);

/********** Upcase DDTOUT */
%let DDTOUT=%upcase(&DDTOUT);

/********** Check, if dataset exists */
%let dsid=%sysfunc(open(&DBIN,i));
%if &dsid=0 %then %do;
    %put ERROR: Macro: &SYSMACRONAME - The Dataset &DBIN does not exist! - ABORT;
    %let rc=%sysfunc(close(&dsid));
    %return;
    %end;
%let rc=%sysfunc(close(&dsid));

/********** Necessary to assign (empty) format to avoid error when there are no formats defined */
proc format; run;quit;

/*******************************************************************;
********** (1) DERIVE MASTER DDT (db00_MASTER) WITH GATHER2() - BEGIN;
********************************************************************/

/*********** Read only 1st Observation of dataset */ 
data db00_OBS1;
    set &DBIN;
    if _N_=1;
run;quit;

/*********** Transpose this dataset from wide to long (output Formats and Labels) */ 
%utl_gather2(db00_OBS1, _VARIABLE_tmp_, _Value_tmp_, , db00_TINY1a, ValFormat=$400., WithFormats=Y, SASFormats=Y);

********** Rename temporary variable;
data db00_TINY1a;
    set db00_TINY1a (rename=(_VARIABLE_tmp_=VARIABLE _Value_tmp_=VALUE));
run;quit;

/********** Load Dataset to library work */ 
data db00_FULL;
    set &DBIN;
run;quit;

/*********** Select Label Format from dictionary.columns*/ 
proc sql;
create table db00_library as
    select NAME, VARNUM, LABEL, FORMAT
    from dictionary.columns
    where libname=upcase("WORK") and upcase(MEMNAME)="DB00_FULL";
quit;

/*********** Final Tiny Dataset */ 
/*********** Variables: Value _IsMissing not neccessary */ 
data db00_TINY1b;
    merge db00_TINY1a (drop=Value _IsMissing) db00_library (drop=name);
run;quit;

/********** Master File for SAS FORMATs */
data db00_MASTER;
    set db00_TINY1b;
    DS_FORMAT=FORMAT;
    FORMAT=_SASFormat;
    format DS_FORMAT_ $4.;
    if DS_FORMAT ne FORMAT then DS_FORMAT_="diff";
label DS_FORMAT="SAS Format";
run;quit;

/*******************************************************************;
********** (1) DERIVE MASTER DDT (db00_MASTER) WITH GATHER2() - END;
********************************************************************/

/******************************************************************;
********** (2) IDENTIFY NO OBSERVATION AND NUMBER OF VARIABLES - BEGIN;
********************************************************************/

proc sql noprint; 
    select count(*) into :NOBSDATASET
    from &DBIN;
quit;

proc sql noprint; 
    select count(*) into :NVARDATASET
    from db00_MASTER;
quit;

%put 'dataframe': &NOBSDATASET obs. of &NVARDATASET variables:;

/*********** Derive Line 1 of str() */ 
data db04_OBS_VAR;
    format LINE $200.;
    LINE=trim("'dataframe': ") || "   " || strip(put(&NOBSDATASET, 8.)) || " obs. of   " || strip(put(&NVARDATASET, 8.)) || " variables:";
run;quit;

/******************************************************************;
********** (2) IDENTIFY NO OBSERVATION AND NUMBER OF VARIABLES - END;
********************************************************************/

/******************************************************************;
********** (3) GENERTAE MASTER DATASET GENERATED WITH GATHER2 - BEGIN;
********************************************************************/

/*********** Transpose Dataset from wide to long (all variables) */ 
%utl_gather2(&DBIN, _VARIABLE_tmp_, _Value_tmp_, , db00_TINY_ALL, ValFormat=$400., WithFormats=Y, SASFormats=Y);

********** Rename temporary variable;
data db00_TINY_ALL;
    set db00_TINY_ALL (rename=(_VARIABLE_tmp_=VARIABLE _Value_tmp_=VALUE));
run;quit;

/******************************************************************;
********** (3) GENERTAE MASTER DATASET GENERATED WITH GATHER2 - END;
********************************************************************/

/*******************************************************************;
********** (4) GENERATE TINY DATASET WITH ALL NUMERIC VARS - BEGIN;
********************************************************************/

/********** Select (real) numeric variables only (BEST or w.d Format) */ 
/********** (exclude num vars e.g. "COMMA", "HEX", "FRACT" "NEGPAREN" "NUMX" "OCTAL" "ODDSR" "ROMAN" "SSN" "PERCENT") */ 
data db00_TINY_NUM;
    set db00_TINY_ALL (keep=VARIABLE VALUE _IsMissing _IsRealNum where=(_IsRealNum=1));
       if _IsMissing="Y" then do;
       Value="";
       end;
label VARIABLE="Variable";
run;quit;

/*******************************************************************;
********** (4) GENERATE TINY DATASET WITH ALL NUMERIC VARS - END;
********************************************************************/

/*******************************************************************;
********** (5) SPLIT NUMERIC VARIABLES IN: LENGTH, PART BEFORE AND AFTER DECIMAL - BEGIN;
********************************************************************/

data db00_NUM_SPLIT;
    set db00_TINY_NUM (drop=_IsMissing _IsRealNum);
    format _LEN 8. _PARTA $32. _PARTB $32. _DIGIT 8. _LEN_PARTA 8. _LEN_PARTB 8.;
    /*********** Length */
    _LEN=length(VALUE);
    /*********** Part before and after decimal point */
    _PARTA=scan(VALUE, 1, ".");
    _PARTB=scan(VALUE, 2, ".");
    /*********** Is Digit after decimal point? */
    if _PARTB="" then _DIGIT=0;
    if _PARTB ne "" then _DIGIT=1;
    /*********** Number of digits before decimal point */
    _LEN_PARTA=length(_PARTA);
    /*********** Number of digits after decimal point */
    _LEN_PARTB=0;
    if _PARTB ne "" then _LEN_PARTB=length(_PARTB);
run;quit;
proc sort data=db00_NUM_SPLIT; by VARIABLE; run;quit;

/*******************************************************************;
********** (5) SPLIT NUMERIC VARIABLES IN: LENGTH, PART BEFORE AND AFTER DECIMAL - END;
********************************************************************/

/*******************************************************************;
********** (6) DERIVE VALUES MAXLENGTH ISPOINT DIGNUM - BEGIN;
********************************************************************/

proc means data=db00_NUM_SPLIT noprint;
    by VARIABLE;
    var _LEN;
    output out=db00_len (drop=_TYPE_ _FREQ_) max=MAXLENGTH;
run;quit;

proc means data=db00_NUM_SPLIT noprint;
    by VARIABLE;
    var _DIGIT;
    output out=db00_digit (drop=_TYPE_ _FREQ_) max=ISPOINT;
run;quit;

proc means data=db00_NUM_SPLIT noprint;
    by VARIABLE;
    var _LEN_PARTB;
    output out=db00_lenB (drop=_TYPE_ _FREQ_) max=DIGNUM;
run;quit;

/*******************************************************************;
********** (6) DERIVE VALUES MAXLENGTH ISPOINT DIGNUM - END;
********************************************************************/

/*******************************************************************;
********** (7) FINAL DETERMINATION OF REAL_DATA_TYPE LENGTH DECIMAL_PLACES - BEGIN;
********************************************************************/

/*********** Merge Final Results (DDT for num values) */ 
data db02_DDT_NUM1a;
    format VARIABLE ;
    format REAL_DATA_TYPE $8. LENGTH 8. DECIMAL_PLACES $2. DISPLAY_FORMAT $16.;
    merge db00_len db00_digit db00_lenB;
    /********** Derive Data Type integer */
    if ISPOINT=0 then REAL_DATA_TYPE="integer";

    /********** Derive Length */
    LENGTH=MAXLENGTH;

    /********** Derive Data Type Float and Significant Digits */
    DECIMAL_PLACES=""; 
    DISPLAY_FORMAT="";
    if ISPOINT=1 then do;
       REAL_DATA_TYPE="float";
       DECIMAL_PLACES=strip(put(DIGNUM, BEST8.));
       DISPLAY_FORMAT=strip(put(LENGTH, BEST8.)) || '.' || strip(DECIMAL_PLACES);
       end;
    
    put 'NOTE: ------------------';
    put 'NOTE: Name of Variable for Determination (integer/float): &DBIN Variable: ' VARIABLE;
    put 'NOTE: Length of Variable: ' MAXLENGTH; 
    put 'NOTE: Decimal Point? (0 = no, 1 = yes): ' ISPOINT;
    put 'NOTE: Data Type: ' REAL_DATA_TYPE;
    put 'NOTE: Length: ' LENGTH ;
    put 'NOTE: Number of Decimal Places: ' DECIMAL_PLACES;
    put 'NOTE: Display Format: ' DISPLAY_FORMAT;

    drop MAXLENGTH DIGNUM;
label REAL_DATA_TYPE="(Real) Data Type"
LENGTH="Length"
DECIMAL_PLACES="Decimal Places"
DISPLAY_FORMAT="Display Format";
run;quit;

/********** Derive STR TYPE */
data db02_DDT_NUM;
    set db02_DDT_NUM1a;
    format STR_TYPE $16.;
    if REAL_DATA_TYPE="integer" then STR_TYPE=trim("int: ") || " " || strip(put(LENGTH, 8.));
    if REAL_DATA_TYPE="float" then STR_TYPE=trim("float: ") || " " || strip(put(DISPLAY_FORMAT, 8.));
    drop ISPOINT;
label STR_TYPE="Parsed Data Type";
run;quit;

/*******************************************************************;
********** (7) FINAL DETERMINATION OF REAL_DATA_TYPE LENGTH DECIMAL_PLACES - END;
********************************************************************/

/*******************************************************************;
********** (8) FINAL DETERMINATION OF MAXIMUM LENGTH OF CHARACTER VARIABLES - BEGIN;
********************************************************************/

/*********** Derive DB with character values */ 
data db00_TINY_CHAR;
    set db00_TINY_ALL (keep=VARIABLE VALUE _ColTyp where=(_ColTyp="char"));
    _LEN=length(VALUE);
run;quit;
proc sort data=db00_TINY_CHAR; by VARIABLE; run;quit;

proc means data=db00_TINY_CHAR noprint;
    by VARIABLE;
    var _LEN;
    output out=db00_len_CHAR (drop=_TYPE_ _FREQ_) max=MAXLENGTH;
run;quit;

/*********** Final Result (DDT for char values) */ 
data db02_DDT_CHAR;
    format VARIABLE ;
    format REAL_DATA_TYPE $8. LENGTH 8.;
    set db00_len_CHAR;
    REAL_DATA_TYPE="text";
    LENGTH=MAXLENGTH;
    format STR_TYPE $16.;
    STR_TYPE=trim("$") || strip(put(LENGTH, 8.)) || ".";
    put 'NOTE: ------------------';
    put 'NOTE: Name of Variable for Determination of maximum Length: &DBIN Variable: ' VARIABLE;
    put 'NOTE: Maximum Length: ' LENGTH; 
    drop MAXLENGTH;
label REAL_DATA_TYPE="Real Data Type"
LENGTH="Length";
run;quit;

/*******************************************************************;
********** (8) FINAL DETERMINATION OF MAXIMUM LENGTH OF CHARACTER VARIABLES - END;
********************************************************************/

/*******************************************************************;
********** (9) DERIVE FACTORS (USERDEFINED SAS FORMATS) - BEGIN;
********************************************************************/

/********** Read Formats in Library Work (and sort by FMTNAME) */;
proc format library=work cntlout=db00_formats1a;
run;quit;
proc sort data=db00_formats1a; by FMTNAME; run;quit;

/*********** Derive Full SAS Format Name */
data db00_formats1b;
    format FMTNAME;
    format FULL_FNAME $49.;
    format LABEL $256.;
    set db00_formats1a;
    ********** Assign $ for char;
    if TYPE="C" then FULL_FNAME=trim("$") || strip(FMTNAME) || "."; * Add sign $ and dot .;
    if TYPE in("N", "P") then FULL_FNAME=trim(strip(FMTNAME)) || "."; * Add dot .;

run;quit;
proc sort data=db00_formats1b; by FULL_FNAME; run;quit;

/*********** Add Sequence Number Level ID */ 
data db00_formats1c;
    format FMTNAME FULL_FNAME;
    format LEVEL_ID 8.;
    set db00_formats1b;
    by FULL_FNAME;
    /********** Generate Sequence Number */
    retain LEVEL_ID;
    if first.FULL_FNAME then LEVEL_ID=0;
    LEVEL_ID=LEVEL_ID+1;
label LEVEL_ID='Level ID';
run;quit;

/********** Count Format Levels */ 
proc sql;
create table db01_LEVELS as 
    select FULL_FNAME, COUNT(FULL_FNAME) label="Level(s)" format=8. as NO_LEVELS
    from db00_formats1b
    group by FULL_FNAME;
quit;

/********** Generate Decodes for Starting Values in Variable FDEFTX */ 
data db00_formats;
    format FDEFTX FORM $1000.;
    set db00_formats1c (keep=FULL_FNAME START LABEL TYPE LEVEL_ID LENGTH);
    /********** Derive Format/Label (unquoted) */
    FDEFTX=trim(strip(START)) || " = " || strip(LABEL);
    /********** In case of Numeric Formats: Derive Format FORM (unquoted) */
    if TYPE="N" then do;
       FORM=strip(START);
       end;
    /********** Special Case: pictrure format */
    if TYPE="P" then do;
       FORM="<PICT>";
       FDEFTX="<PICT>";
       end;
    /********** In case of Character Formats: Derive Format FORM (quoted) */
    if TYPE="C" then do;
       if not missing(dequote(START)) then FORM=quote(strip(START));
       if missing(dequote(START)) then FORM='""';
       end;
    keep FULL_FNAME FDEFTX TYPE FORM START LABEL LEVEL_ID LENGTH;
run;quit;

/********** Generate Code for R Factor c(x,y) - do NOT exclude numeric format with dot */ 
/********** NOTE: A dot for numeric SAS values correspond to missing ('NA' in R) */ 
/********** Will be counted as Factor here*/
data db00_R_factor;
    format DDTFORMAT $49.;
    format FORMCD $4000.;
    set db00_formats; 
    by FULL_FNAME;
    retain FORMCD;
    if first.FULL_FNAME then FORMCD=FORM;
    if not(first.FULL_FNAME) then FORMCD=trim(FORMCD) || ", " || (FORM);
    /********** Output when last: */
    if last.FULL_FNAME then do;
        DDTFORMAT=FULL_FNAME;
        output;
        end;
    keep DDTFORMAT FORMCD;
run;quit;
proc sort data=db00_R_factor; by DDTFORMAT; run;quit;

/********** Generate Code for R levels c("x","y") */
data db00_R_level;
    format DDTFORMAT $49.;
    format LEVELCD $4000.;
    set db00_formats;
    by FULL_FNAME;
    retain LEVELCD;
    HELP=quote(strip(LABEL));
    if first.FULL_FNAME then LEVELCD=HELP;
    if not(first.FULL_FNAME) then LEVELCD=trim(LEVELCD) || ", " || (HELP);
    /********** Output when last */
    if last.FULL_FNAME then do;
       DDTFORMAT=FULL_FNAME;
       output;
       end;
keep DDTFORMAT LEVELCD;
run;quit;
proc sort data=db00_R_level; by DDTFORMAT; run;quit;

/*********** Generate List of Decodes (e.g. N = No, Y = Yes) for all (character and numeric) Formats */
data db00_Decode;
    format DDTFORMAT $49.;
    format DECODE $4000.;
    set db00_formats;
    by FULL_FNAME;
    retain DECODE;
    if first.FULL_FNAME then DECODE=FDEFTX;
    if not(first.FULL_FNAME) then DECODE=trim(DECODE) || ", " || (FDEFTX);
    /********** Output when last */
    if last.FULL_FNAME then do;
       DDTFORMAT=FULL_FNAME;
       output;
       end;
    keep DDTFORMAT DECODE;
label DECODE="Decode";
run;quit;
proc sort data=db00_Decode; by DDTFORMAT; run;quit;


/******************************************************************;
********** - DERIVE LEVELS BY PARSING THE DATASET - BEGIN;
********************************************************************/

/********** Read DB with user-defined Formats */
data db00_tiny_ALL_USER;
    set Db00_tiny_all (where=(_ColTyp="USER DEFINED"));
    format FORMAT $49.;
    FORMAT=_SASFormat;
    RUN_ID=_N_;
    drop _ColFormat;
run;quit;
proc sort data=db00_tiny_ALL_USER; by FORMAT VALUE; run;quit;

proc sort data=db00_formats; by FULL_FNAME LABEL; run;quit;

/********** Merge File and Format by FORMAT VALUE */
data db01_LEV;
    merge db00_tiny_ALL_USER (in=DE) db00_formats (keep=FULL_FNAME LABEL LEVEL_ID rename=(FULL_FNAME=FORMAT LABEL=VALUE));
    by FORMAT VALUE;
    if DE=1;
run;quit;
proc sort data=db01_LEV; by FORMAT VARIABLE RUN_ID; run;quit;

/********** Generate ROW with Levels */
data db01_LEVTX1a;
    format ROW_TX $200.;
    set db01_LEV (keep=FORMAT VARIABLE LEVEL_ID);
    by FORMAT VARIABLE;
    retain ROW_TX;
    /**********  Allow numeric values with vvalue() */
    _HELPTX=left(vvalue(LEVEL_ID));
    if first.VARIABLE then ROW_TX=_HELPTX;
    if not(first.VARIABLE) then ROW_TX=trim(ROW_TX) || ", " || (_HELPTX);
    drop _HELPTX LEVEL_ID;
run;quit;

/********** Select last obstervation only */
data db01_LEVTX1b;
    format FORMAT ROW_TX;
    set db01_LEVTX1a;
    by FORMAT VARIABLE;
    if last.VARIABLE;
run;quit;

/********** Modify ROW with Levels (29 char. only) */
data db01_LEVTX;
    set db01_LEVTX1b;
    format _ROW $200. DATA_R_FORMAT $29.;
    /********** Replace missing character with NA */
    _ROW=tranwrd(ROW_TX, '.,', 'NA');
    _ROW=tranwrd(_ROW, '.', 'NA');
    _ROW=COMPBL(tranwrd(_ROW, ',', ''));
    /********** Add ... at the end, if too long */
    if length(_ROW)>26 then do;
       DATA_R_FORMAT=left(trim(input(_ROW, $26.)) || "...");
       end;
    else do;
       DATA_R_FORMAT=_ROW;
       end;
    keep FORMAT VARIABLE DATA_R_FORMAT;
run;quit;

/******************************************************************;
********** - DERIVE LEVELS BY PARSING THE DATASET - END;
********************************************************************/

/*********** User Defined Formats */
data db00_tiny_user;
    set db00_MASTER (keep=VARIABLE _ColTyp _ColFormat _UserDef FORMAT where=(_ColTyp="USER DEFINED"));
run;quit;
proc sort data=db00_tiny_user; by FORMAT VARIABLE; run;quit;

/********** Identify length of Format (Definition) */
proc sql;
create table db00_FLENGHT as 
    select FULL_FNAME as FORMAT, max(LENGTH) label="Length of Format" format=8. as FOR_LENGTH
    from db00_formats
    group by FULL_FNAME;
quit;

/********** Identify max length of Value in Dataset */
proc sql;
create table db00_DB_LENGTH as 
    select FORMAT, max(length(VALUE)) label="Length of Format in DB" format=8. as DB_LENGTH
    from db00_tiny_ALL_USER (where=(_IsMissing ne "Y"))
    group by FORMAT;
quit;

/*********** Merge Files with R factors, R Levels, Decodes (check for avoiding MERGE STATEMENT, tbd SQL code)*/
data db02_DDT_user1a;
    merge db00_tiny_user (in=de) db01_LEVELS (rename=FULL_FNAME=FORMAT) db00_Decode (rename=DDTFORMAT=FORMAT) 
          db00_R_factor (rename=DDTFORMAT=FORMAT) db00_R_level (rename=DDTFORMAT=FORMAT)
          db01_LEVTX db00_FLENGHT db00_DB_LENGTH;
    by FORMAT;
    if DE=1;
run;quit;

/********** Check for truncated user-def char. formats (tbd) */ 
data db02_DDT_user;
    set db02_DDT_user1a;
    format REAL_DATA_TYPE $8.;
    REAL_DATA_TYPE="format";
    /********** t.b.d. check if formats are truncated (e.g. 'Fema' $SEX4. instead of 'Female') */
    format DDT_REM $80.;
    DDT_REM="";
    drop _ColTyp _ColFormat FORMAT;
run;quit;

/*******************************************************************;
********** (9) DERIVE FACTORS (USERDEFINED SAS FORMATS) - END;
********************************************************************/

/******************************************************************;
********** (10) DATE DTM TIME - BEGIN;
********************************************************************/

/********** Date/Datetimes/Times */ 
data db02_DDT_DTM;
    set db00_MASTER (keep=VARIABLE _ColTyp where=(_ColTyp in ("date", "datetime", "time")));
    drop _ColTyp;
    format REAL_DATA_TYPE $8.;
    REAL_DATA_TYPE=_ColTyp;
run;quit;

/******************************************************************;
********** (10) DATE DTM TIME - END;
********************************************************************/

/******************************************************************;
********** (11) IDENTIFY SCIENTIFIC FORMAT - BEGIN;
********************************************************************/

********** Identify Scientific Format;
data db02_DDT_scientific;
    set db00_MASTER (keep=VARIABLE _ColFormat _IsRealNum where=(_IsRealNum eq 0));
    /********** Scientific: Numeric and begins with E */
    if substr(_ColFormat, 1, 1)="E" then do;
       STR_TYPE="Scientific";
       output;
       end;
    keep VARIABLE STR_TYPE;
run;quit;

/******************************************************************;
********** (11) IDENTIFY SCIENTIFIC FORMAT - END;
********************************************************************/

/******************************************************************;
********** (12) DERIVE DATA_ROW_ORIG FOR ALL VARIABLES - BEGIN ;
********************************************************************/

/********** Sort DB by Variable */
proc sort data=db00_tiny_ALL; by VARIABLE; run;quit;

/********** Generate ROW with Levels */
data db01_ROW1a;
    format ROW_TX $200.;
    set db00_tiny_ALL (keep=VARIABLE VALUE);
    by VARIABLE;
    /********** Assign , to missing Values */
    if VALUE="" then VALUE=",";
    /********** Use retain to hold values */
    retain ROW_TX;
    _HELPTX=left(vvalue(VALUE)); * allows num values;
    if first.VARIABLE then ROW_TX=_HELPTX;
    if not(first.VARIABLE) then ROW_TX=trim(ROW_TX) || " " || (_HELPTX);
    drop _HELPTX;
run;quit;

/********** Select last obstervation only */
data db01_ROW1b;
    format ROW_TX;
    set db01_ROW1a;
    by VARIABLE;
    if last.VARIABLE;
run;quit;

/********** Modify ROW with Levels (65 char. only) */
data db03_ROW;
    set db01_ROW1b;
    format _ROW $200. DATA_ROW_ORIG $65.;
    _ROW=ROW_TX;
    /********** Add ... at the end, if too long */
    if length(_ROW)>62 then do;
       DATA_ROW_ORIG=left(trim(input(_ROW, $62.)) || "...");
       end;
    else do;
       DATA_ROW_ORIG=_ROW;
       end;
    keep VARIABLE DATA_ROW_ORIG;
run;quit;

/******************************************************************;
********** (12) DERIVE DATA_ROW_ORIG FOR ALL VARIABLES - END;
********************************************************************/

/********** Count missing values */
proc sql;
create table db02_miss as 
    select VARIABLE,
    COUNT(VARIABLE) label="Missing Values" format=8. as NO_MISS
    from Db00_tiny_all (where=(_IsMissing="Y"))
    group by VARIABLE;
quit;

proc sort data=db00_MASTER; by VARIABLE; run;quit;

/********** Derive no. of missing values */
data db03_VALUES;
    merge db00_MASTER (keep=VARIABLE) db02_miss;
    by VARIABLE;
    format VALID_N 8. OVERALL_N 8.;
    OVERALL_N=&NOBSDATASET;
    if NO_MISS=. then NO_MISS=0;
    /********** Identify all blank */
    format PARSED $5.;
    if NO_MISS=OVERALL_N then PARSED="blank";
    /********** Calculate Valid No */
    VALID_N=OVERALL_N-NO_MISS;
    /********** Calculate missing percent */
    format MISS_ND $16. MISS_PERCENT $8.;
    if NO_MISS ne 0 then do;
       MISS_ND=trim(strip(put(NO_MISS, 8.))) || "/" || strip(put(OVERALL_N, 8.));
       MISS_PERCENT=trim("(") || strip(put(NO_MISS/OVERALL_N*100, 5.1)) || "%)";
       end;
label MISS_ND="Missing Values"
MISS_PERCENT="Missing Values (%)"
VALID_N="Valid N";
run;quit;


/******************************************************************;
********** (13) GENERATE FINAL DDT - BEGIN;
********************************************************************/

/********** SET ALL FILES INTO DB */
data db04_DDT_USED;
    set db02_DDT_char Db02_ddt_num Db02_ddt_dtm Db02_ddt_user db02_DDT_scientific;
run;quit;
proc sort data=db04_DDT_USED; by VARIABLE; run;quit;

/********** FINAL MERGE (including variables, that are not parsed, e.g. type 'curr' */
data db04_DDT_FULL;
    merge db00_MASTER (in=DE1) db04_DDT_USED (in=DE2) db03_VALUES db03_ROW;
    by VARIABLE;
    if DE1 eq 1 and DE2 ne 1 then DDT_REM="NOT PARSED";
run;quit;
proc sort data=db04_DDT_FULL; by VARNUM; run;quit;

/********** FINAL DDT */ 
data DDT_FINAL;
    format VARNUM 8.;
    format VARIABLE;
    format LABEL $256. MISS_ND;
    format FORMAT $49. DS_FORMAT $49. STR_TYPE REAL_DATA_TYPE LENGTH DISPLAY_FORMAT DISPLAY_FORMAT _USERDEF DECODE DDT_REM ;
    set db04_DDT_FULL;
    /********** When missing REAL_DATA_TYPE assign REAL_DATA_TYPE, e.g. "curr" */
    if REAL_DATA_TYPE="" then REAL_DATA_TYPE=_ColTyp;
    format DATA_ROW $200.;
    DATA_ROW=DATA_R_FORMAT;
    /********** Picture Format */ 
    if substr(DECODE, 1, 6) eq "<PICT>" then DECODE="<Picture Format>";
    /********** Scientific Notation */
    if STR_TYPE="Scientific" then DDT_REM="SCIENTIFIC NOTATION";
    /********** Correction for Picture Format */ 
    if DECODE="<Picture Format>" then do;
       DDT_REM="PICTURE FORMAT";
       DATA_R_FORMAT=DATA_ROW_ORIG;
       DATA_ROW="<PICT>";
       end;
    /********** Short Factor */ 
    format FORMAT_CD $30.;
    FORMAT_CD=trim(substr(LEVELCD, 1, 27));
    if length(LEVELCD)>27 then FORMAT_CD=trim(FORMAT_CD) || "...";
    /********** Add Labels */
label _USERDEF='User Defined (num, char)'
DDT_REM='DDT Remark'
_ColFormat='Column Format'
_ColTyp='Column Type'
_ColTypVar='Column Type (N, C)'
_IsRealNum='Real num Type (1 = BESTw. or w.d)'
_SASFormat='SAS Format (with defaults)'
DS_FORMAT_='SAS Format Flag'
FORMCD='Format Code'
LEVELCD='Format Level'
DATA_R_FORMAT='Data R Format'
OVERALL_N='Overall N'
PARSED='Parsed'
DATA_ROW_ORIG='Data Row Original Values'
DATA_ROW='Data Row Levels (Factors)'
FORMAT_CD='Format Code (abbreviated)'
;
run;quit;

/******************************************************************;
********** (13) GENERATE FINAL DDT - BEGIN;
********************************************************************/

/******************************************************************;
********** (14) STR TABLE - BEGIN;
********************************************************************/

/*********** Derive maximum length of SAS Variables */ 
proc sql noprint; 
    select max(length(VARIABLE)) into :MAXLENVAR
    from db00_MASTER;
quit;

%put "NOTE: Maximum length(VARIABLE):" &MAXLENVAR;

/********** Assign $ and : to Variable  */ 
data db04_DDT_LINE1a;
    format LINE1 LINE1a LINE1b $200.;
    set DDT_FINAL (keep=VARIABLE DECODE VARNUM LABEL FORMAT DS_FORMAT DS_FORMAT_ REAL_DATA_TYPE LENGTH STR_TYPE DECIMAL_PLACES 
                   DISPLAY_FORMAT NO_LEVELS LEVELCD FORMAT_CD DATA_R_FORMAT DATA_ROW_ORIG DDT_REM PARSED);
    format NO_LEVELS 8.;
    /********** Put colon at (right) position relative to variable length &MAXLENVAR+3 */
    LINE1a=trim(" $") || " " || strip(VARIABLE );
    substr(LINE1a, &MAXLENVAR+4, 1)=":";
    /********** Depending on data type assign: */
    if REAL_DATA_TYPE="text" then do;
       LINE1b=trim(" chr") || " " || DATA_ROW_ORIG;
       end;
    /********** Format Integer */
    if REAL_DATA_TYPE="integer" then do;
       LINE1b=trim(" int") || " " || DATA_ROW_ORIG;
       end;
    /********** Format Float */
    if REAL_DATA_TYPE="float" then do;
       LINE1b=trim(" num") || " " || DATA_ROW_ORIG;
       end;
    /********** Format Factor */
    if REAL_DATA_TYPE="format" then do;
       LINE1b=trim(" Factor w/") || " " || strip(put(NO_LEVELS, BEST8.)) || " levels " || strip(FORMAT_CD) || " " || DATA_R_FORMAT; 
       end;
    /********** Format Date */
    if REAL_DATA_TYPE="date" then do;
       LINE1b=trim(" date") || " " || DATA_ROW_ORIG;
       end;
    /********** Format Datetime */
    if REAL_DATA_TYPE="datetime" then do;
       LINE1b=trim(" dtim") || " " || DATA_ROW_ORIG;
       end;
    /********** Format Date */
    if REAL_DATA_TYPE="time" then do;
       LINE1b=trim(" tim") || " " || DATA_ROW_ORIG;
       end;
    /********** All other */
    if LINE1b="" then do;
       LINE1b=trim(" ") || strip(REAL_DATA_TYPE) || " " || DATA_ROW_ORIG;
       end;
    LINE1=trim(LINE1a) || LINE1b;
    drop LINE1a LINE1b;
run;quit;

/********** Assign SAS Format to Variable */ 
data db04_DDT_LINE1b;
    format LINE1 LINE2 $200.;
    set db04_DDT_LINE1a;
    /********** LINE 2 */
    LINE2="";
    substr(LINE2, &MAXLENVAR+4, 1)=":";
    if DS_FORMAT ne "" then do;
       LINE2=trim(LINE2) || " SAS Format: " || DS_FORMAT;
       end;
    if DS_FORMAT eq "" then do;
       LINE2=trim(LINE2) || " SAS Format: not def., default: " || strip(FORMAT);
       end;
    /********** Format text */
    if REAL_DATA_TYPE="text" and PARSED ne "blank" then do;
       LINE2=trim(LINE2) || " (real length: " || strip(put(LENGTH, 8.)) || ")";
       end;
    /********** Format Integer */
    if REAL_DATA_TYPE="integer" and PARSED ne "blank" then do;
       LINE2=trim(LINE2) || " (" || quote('integer:') || ", length: " || strip(put(LENGTH, 8.)) || ")";
       end;
    /********** Format Float */
    if REAL_DATA_TYPE="float" then do;
       LINE2=trim(LINE2) || " (" || quote('float:') || ", display format: " || strip(DISPLAY_FORMAT) || ")";
       end;
    /********** Scientific Format */
    if STR_TYPE="Scientific" then do;
       LINE2=trim(LINE2) || " <Scientific Notation>" ; 
       end;
    /********** Paresd blank */
    if PARSED="blank" then do;
       LINE2=trim(LINE2) || " <all values missing>" ; 
       end;
    /********** Picture Format */
    if DECODE="<Picture Format>" then do;
       LINE2=trim(LINE2) || " - PICTURE FORMAT"; 
       end;       
run;quit;

/********** Assign Label to Variable */ 
data db04_DDT_LINE;
    format LINE1 LINE2 LINE3 $200.;
    set db04_DDT_LINE1b;
    LINE3="";
    /********** LINE 3 */
    if LABEL ne "" then do;
       substr(LINE3, &MAXLENVAR+4, 1)=":";
       LINE3=trim(LINE3) || " Label: " || quote(strip(LABEL));
       end;
run;quit;

/********** Derive final STR file lines */
data db05_STR1a;
    set db04_DDT_LINE (keep=LINE1 LINE2 LINE3 LABEL);
    LINE=LINE1;
    output;
    LINE=LINE2;
    output;
    if LABEL ne "" then do;
       LINE=LINE3;
       output;
       end;
run;quit;

/********** FINAL STR DATASET (for SAS LOG) */ 
data DDT_STR;
    set db04_OBS_VAR db05_STR1a (keep=LINE);
run;quit;

/******************************************************************;
********** (14) STR TABLE - END;
********************************************************************/

/********** SHORT DDT */ 
data DDT_FINAL_SHORT;
    format VARNUM VARIABLE LABEL MISS_ND FORMAT DS_FORMAT STR_TYPE _ColTypVar REAL_DATA_TYPE LENGTH DISPLAY_FORMAT DISPLAY_FORMAT _USERDEF DECODE DDT_REM DATA_ROW_ORIG;
    set DDT_FINAL (keep=VARNUM VARIABLE LABEL MISS_ND FORMAT DS_FORMAT STR_TYPE _ColTypVar REAL_DATA_TYPE LENGTH DISPLAY_FORMAT DISPLAY_FORMAT _USERDEF DECODE DDT_REM DATA_ROW_ORIG);
run;quit;

%if &DDTOUT=Y %then %do;
title1 "SAS Macro str2() Data Definition Table for dataset: &DBIN";
*footnote1 "NOTE: If all values are 'blank' OR 'missing', the (parsed) Display Format will be assigned to $1. OR integer with length = 1 ('int: 1')";
proc report data=DDT_FINAL_SHORT nowd split="~" ls=160 headskip headline missing;
    column VARIABLE LABEL MISS_ND DS_FORMAT STR_TYPE DECODE;
    define VARIABLE / width=20 flow;
    define LABEL / width=40 flow;
    define MISS_ND / width=10 flow;
    define DS_FORMAT / width=16 flow;
    define STR_TYPE / "(Parsed) Length~Display Format" width=16 flow;
    define DECODE / width=40 flow;
run;quit;
%end;

/********** Delete temporary Datasets  */
proc datasets; delete db0: / gennum=all; run;quit;

/********** FINAL STR IN SAS LOG (keep leading blanks) */
data _NULL_;
    set DDT_STR;
    POS1=verify(LINE, ' ');
    put @POS1 LINE $;;
run;quit;
%mend utl_str2;