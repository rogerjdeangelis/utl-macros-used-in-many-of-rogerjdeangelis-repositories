%macro getFileStem(pth)/des="Extract the path without the file name and extension";
  %local revstr cutstr gotstm;
  %let revstr=%qleft(%qsysfunc(reverse(&pth)));
  %let cutstr=%qsubstr(&revstr,%qsysfunc(indexc(&revstr,%str(/\))));
  %let gotstm=%qleft(%qsysfunc(reverse(&cutstr)));
     %str(&gotstm)
%mend getFileStem;
