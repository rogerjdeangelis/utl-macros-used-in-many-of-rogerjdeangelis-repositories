%macro utl_copysheet(                                                                                      
frombook=c:\top\xls&pgm._100rpt.xlsx                                                                       
,tobook=c:\top\xls&pgm._200rpt.xlsx                                                                        
,fromsheet=utl_200rpt                                                                                      
)/ des="Copy a sheet from one workbook to the another workbook";                                           
                                                                                                           
%local __cmd;                                                                                              
                                                                                                           
/*                                                                                                         
  For testing without macro call                                                                           
  %let frombook=c:\top\xls\&pgm._100rpt.xlsx;                                                              
  %let tobook=c:\top\xls\&pgm._200rpt.xlsx;                                                                
  %let fromsheet=utl_200rpt;                                                                               
  %let tosheet=utl_100rpt;                                                                                 
*/                                                                                                         
                                                                                                           
proc sql;                                                                                                  
 create                                                                                                    
   table __utl_copysheet (chr char(80));insert into __utl_copysheet                                        
VALUES("$xl = new-object -c excel.application                                              ")              
VALUES("$file1 = '&frombook' # source's fullpath                                           ")              
VALUES("$file2 = '&tobook' # destination's fullpath                                        ")              
VALUES("$xl = new-object -c excel.application                                              ")              
VALUES("$xl.displayAlerts = $false # don't prompt the user                                 ")              
VALUES("$wb1 = $xl.workbooks.open($file1, $null, $true) # open source, readonly            ")              
VALUES("$wb2 = $xl.workbooks.open($file2) # open target                                    ")              
VALUES("$sh1_wb2 = $wb2.sheets.item(1) # first sheet in destination workbook               ")              
VALUES("$sheetToCopy = $wb1.sheets.item('&fromsheet') # source sheet to copy")                             
VALUES("$sheetToCopy.copy($sh1_wb2) # copy source sheet to destination workbook            ")              
VALUES("$wb1.close($false) # close source workbook w/o saving                              ")              
VALUES("$wb2.close($true) # close and save destination workbook                            ")              
VALUES("$xl.quit()                                                                         ")              
VALUES("spps -n excel                                                                      ")              
;quit;                                                                                                     
                                                                                                           
%utlfkil(%sysfunc(pathname(work))\ps1.ps1);                                                                
                                                                                                           
filename _ps1 "%sysfunc(pathname(work))\ps1.ps1";                                                          
data _null_;                                                                                               
  length cmd $4096;                                                                                        
  file _ps1;                                                                                               
  set __utl_copysheet;                                                                                     
  put chr;                                                                                                 
  putlog chr;                                                                                              
  if _n_=1 then do;                                                                                        
    cmd=catx(' ',"'powershell -Command",cats('"',"%sysfunc(pathname(work))\ps1.ps1",cats('"',"'")));       
    putlog cmd=;                                                                                           
    call symputx('__cmd',cmd);                                                                             
  end;                                                                                                     
run;quit;                                                                                                  
                                                                                                           
options xwait xsync;run;quit;                                                                              
systask kill _ps1;                                                                                         
systask command &__cmd taskname=_ps1;                                                                      
waitfor _ps1;                                                                                              
%mend utl_copysheet;                                                                                       
