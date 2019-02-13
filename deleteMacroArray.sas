%macro deleteMacArray(arr);
  %local J;
  %do J = 0 %to &&&arr.n;
    %put &arr.&J.*;
    %symdel &arr.&J. / NOWARN;
  %end;
  %symdel &arr.n / nowarn;
%mend deleteMacArray;
