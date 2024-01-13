%macro getFileExtension(pth)/des="get file name without extension";
  %qscan(&pth,-1,'.')
%mend getFileExtension;
