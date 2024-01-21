/ Program   : attrn
/ Version   : 1.0
/ Author    : Roland Rashleigh-Berry
/ Date      : October 2002
/ Contact   : rolandberry@hotmail.com
/ Purpose   : To return a numeric attribute of a dataset
/ SubMacros : none
/ Notes     : This is a low-level utility macro that other shell macros will call
/             The full list of attributes can be found in the SAS documentation.
/             The most common ones used will be CRDTE and MODTE (creation and
/             last modification date), NOBS and NLOBS (number of observations and
/             number of logical [i.e. not marked for deletion] observations) and
/             NVARS (number of variables).
/ Usage     : %let nobs=%attrn(dsname,nlobs);
/
/================================================================================
/ PARAMETERS:
/-------name------- -------------------------description-------------------------
/ ds                Dataset name (pos)
/ attrib            Attribute (pos)
/================================================================================
/ AMENDMENT HISTORY:
/ init --date-- mod-id ----------------------description-------------------------
/
/================================================================================
/ This is public domain software. No guarantee as to suitability or accuracy is
/ given or implied. User uses this code entirely at their own risk.
/===============================================================================*/
%macro attrn(ds,attrib);
%local dsid rc;
%let dsid=%sysfunc(open(&ds,is));
%if &dsid EQ 0 %then %do;
  %put ERROR: (attrn) Dataset &ds not opened due to the following reason:;
  %put %sysfunc(sysmsg());
%end;
%else %do;
%left(%sysfunc(attrn(&dsid,&attrib)))
  %let rc=%sysfunc(close(&dsid));
%end;
%mend attrn;
