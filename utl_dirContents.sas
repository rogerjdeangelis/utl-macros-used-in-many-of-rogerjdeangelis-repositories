%macro utl_dirContents(
 dir= /* directory name to process */
, ext= /* optional extension to filter on */
, dsout=work.dir_contents /* dataset name to hold the file names */
, attribs=Y /* get file attributes? (Y/N ) */
);
/*
michael.goulding@experis.com
https://www.pharmasug.org/proceedings/2015/QT/PharmaSUG-2015-QT23.pdf
*/
%global _dir_fileN;
%local _syspathdlim _exitmsg _attrib_vars;
%* verify the required parameter has been provided. ;
%if %length(&dir) = 0 %then %do;
 %let _exitmsg = %str(E)RROR: No directory name specified - macro will exit.;
 %goto finish;
%end;
%* verify existence of the requested directory name. ;
%if %sysfunc(fileexist(&dir)) = 0 %then %do;
 %let _exitmsg = %str(E)RROR: Specified input location, &dir., does not exist - macro
will exit.;
 %goto finish;
%end;
%* set the separator character needed for the full file path: ;
%* (backslash for Windows, forward slash for UNIX systems) ;
%if &sysscp = WIN %then %do;
 %let _syspathdlim = \;
%end;
%else %do;
 %let _syspathdlim = /;
%end;
/*--- begin data step to capture names of all file names found in the specified
directory. ---*/
data &dsout(keep=file_seq basefile pathname);
 length basefile $ 40 pathname $ 1000 _msg $ 1000;
 /* Allocate directory */
 rc=FILENAME('xdir', "&dir");

 if rc ne 0 then do;
 _msg = "E" || 'RROR: Unable to assign fileref to specified directory. ' ||
sysmsg();
 go to finish_datastep;
 end;
 /* Open directory */
 dirid=DOPEN('xdir');
 if dirid eq 0 then do;
 _msg = "E" || 'RROR: Unable to open specified directory. ' || sysmsg();
 go to finish_datastep;
 end;
 /* Get number of information items */
 nfiles=DNUM(dirid);
 do j = 1 to nfiles;
 basefile = dread(dirid, j);
 pathname=strip("&dir") || "&_syspathdlim." || strip(basefile);

 %if %length(&ext) %then %do;
/* scan the final "word" of the full file name, delimited by dot character. */

 ext = scan(basefile,-1,'.');
 if ext="&ext." then do;
 file_seq + 1;
 output;
 end;
 %end;
 %else %do;
 file_seq + 1;
 output;
 %end;
 end;
 /* Close the directory */
 rc=DCLOSE(dirid);
 /* Deallocate the directory */
 rc=FILENAME('xdir');

 call symputx('_dir_fileN', file_seq);
 finish_datastep:
 if _msg ne ' ' then do;
 call symput('_exitmsg', _msg);
 end;
run;
%if %upcase(&attribs)=Y and &_dir_fileN > 0 %then %do;
 data _file_attr(keep=file_seq basefile infoname infoval);
 length infoname infoval $ 500;
 set &dsout.;
/* open each file to get the additional attributes available. */
 rc=filename("afile", pathname);
 fid=fopen("afile");
/* return the number of system-dependent information items available for the
external file. */
 infonum=foptnum(fid);
/* loop to get the name and value of each information item. */
 do i=1 to infonum;
 infoname=foptname(fid,i);
 infoval=finfo(fid,infoname);
 if upcase(infoname) ne 'FILENAME' then output;
 end;
 close=fclose(fid);
 run;
 /* transpose each information item into its own variable */
 proc transpose data=_file_attr out=trans_attr(drop=_:) ;
 by file_seq basefile ;
 var infoval;
 id infoname;
 run;
 proc sql noprint;
 select distinct name into : _attrib_vars separated by ', '
 from dictionary.columns
 where memname='TRANS_ATTR' and upcase(name) not in('BASEFILE', 'FILE_SEQ')
 order by varnum;
 quit;
 /* merge back the additional attributes to the related file name. */
 data &dsout.;
 merge &dsout. trans_attr;
 by file_seq basefile;
 run;
 proc datasets nolist memtype=data lib=work;
 delete _file_attr trans_attr;
 run;
 quit;
%end;
%if %length(&_exitmsg) = 0 %then
%let _exitmsg = NOTE: &dsout created with &_dir_fileN. file names ;
%if %length(&ext) %then
%let _exitmsg = &_exitmsg where extension is equal to &ext.;
%let _exitmsg = &_exitmsg from &dir..;
%finish:
%put &_exitmsg;
%if %length(&_attrib_vars) ne 0 %then %do;
 %put;
 %put NOTE: File attributes were requested and have been added to &dsout.. Variable
names are &_attrib_vars.;
%end;
%mend utl_dirContents;

