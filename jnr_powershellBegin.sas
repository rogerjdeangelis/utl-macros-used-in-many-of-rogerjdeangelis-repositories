%macro jnr_powershellBegin(
    resolve=Y
    )/des="No additional quote(backtic) because powershell needs it";

  %local pth;
  %let pth=%sysfunc(pathname(workx));

  %utlfkil(&pth/powershell_resolve.ps1);

  data _null_;
    length _infile_ $255;
    file "&pth/powershell_resolve.ps1";
    input;
    if upcase("&resolve")=:"Y" then _infile_=resolve(_infile_);
    put _infile_;
    putlog _infile_;

%mend jnr_powershellBegin;
