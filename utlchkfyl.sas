%macro utlchkfyl(file) / delete file if it exists;
  %if %sysfunc(fileexist(&file)) ge 1 %then %do;
    %let rc=%sysfunc(filename(temp,&file));
    %let rc=%sysfunc(fdelete(&temp));
  %end;
%else %put The file &file does not exist;
%mend utlchkfyl;
