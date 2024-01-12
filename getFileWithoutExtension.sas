%macro getFileWithoutExtension(pth)/des="get file name without extension";
  %qscan(&pth,-2,'./\')
%mend getFileWithoutExtension;
