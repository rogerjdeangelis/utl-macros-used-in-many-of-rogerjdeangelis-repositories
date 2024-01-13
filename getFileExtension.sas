%macro getFileExtension(pth)/des="get file extension ie sas";
  %qscan(&pth,-1,'.')
%mend getFileExtension;
