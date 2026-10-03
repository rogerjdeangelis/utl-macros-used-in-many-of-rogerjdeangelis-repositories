%macro jnr_duckbeginx(
    resolve=Y
    )/des="Allow additional quote(backtic) and provide for macro resolution";

  %local pth;
  %let pth=%sysfunc(pathname(work));

  %utlfkil(&pth/duck_resolve.sql);

  data _null_;
    length _infile_ $255;
    file "&pth/duck_resolve.sql";
    input;
    if upcase("&resolve")=:"Y" then _infile_=resolve(_infile_);
    if index(_infile_,"`") then
        _infile_=translate(_infile_,"27"x,"`");
    put _infile_;
    putlog _infile_;

%mend jnr_duckbeginx;
