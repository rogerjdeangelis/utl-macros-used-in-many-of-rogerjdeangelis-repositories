%macro aix/cmd des="Read ai results from clipboard and format result for ms word d:/xls/search#.xlsx";
   %let _idx=&sysindex;
   %dosubl(%nrstr(
       %utlfkil(d:/xls/&name..xls);
       ods listing close;
       ods escapechar='~';
       ods excel file="d:/xls/&name..xlsx" style=journal3a;
       ods excel options(
             absolute_column_width = "7in"
             frozen_headers     = '1'
             row_heights        = "0.75in"
             embedded_titles    = "yes"
             embedded_footnotes = "yes");
       ods excel options(sheet_name="&name" );
       proc report data=preprocess style=journal noheader;
       cols
           name
           request
           ;
       define Name   / group "Name"  noprint width=80 flow style(column)={just=left font_size=10pt font_weight=bold};
       define Request  / order "Request"  width=120 flow style(column)={vjust=top font_size=10pt};
       break after name / page style={just=left};
       compute before name / style={just=left font_weight=bold fontsize=10pt};
        line name $200.;
        skp=' ';
        line skp $2.;
       endcomp;
       run;quit;
       ods excel close;
       ods listing;
      ods listing;
   ));
%mend aix;
