%macro getFileWithExtension(pth) / des="Extract the file with extension from the full path";
  %local revpth gotfyl;
  %let revpth=%qleft(%qscan(%qsysfunc(reverse(&Pth)),1,%str(/\)));
  %let gotfyl=%qleft(%qsysfunc(reverse(&revpth)));
     %str(&gotfyl)
%mend getfilewithextension;
