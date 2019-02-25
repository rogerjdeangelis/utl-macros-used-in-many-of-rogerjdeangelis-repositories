%macro utl_decodeBase64(inp=,out=);
   /* Chang Chung */
   %put %sysfunc(ifc(%sysevalf(%superq(inp)=,boolean),**** Please Provide the input file       ****,));
   %put %sysfunc(ifc(%sysevalf(%superq(out)=,boolean),**** Please Provide an output file       ****,));
    %let res= %eval
    (
        %sysfunc(ifc(%sysevalf(%superq(inp)=,boolean),1,0))
      + %sysfunc(ifc(%sysevalf(%superq(out)=,boolean),1,0))
    );
     %if &res = 0 %then %do;
         %utl_submit_py64("
         import base64;
         with open('&inp', 'rb') as g:;
         .    b64encode_from_file=g.read();
         decoded=base64.b64decode(b64encode_from_file);
         with open('&out', 'wb') as w:;
         .    w.write(decoded);
         ");
     %end;
%mend utl_decodeBase64;
