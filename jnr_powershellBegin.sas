%macro jnr_powershellBegin(
    resolve=Y
    )/des="No additional quote(backtic) because powershell needs it";

  %local pth;
  %let pth=%sysfunc(pathname(work));

  %utlfkil(&pth/perl_resolve.pl);

  data _null_;
    length _infile_ $255;
    file "&pth/perl_resolve.pl";
    input;
    if upcase("&resolve")=:"Y" then _infile_=resolve(_infile_);
    put _infile_;
    putlog _infile_;

%mend jnr_powershellBegin;
