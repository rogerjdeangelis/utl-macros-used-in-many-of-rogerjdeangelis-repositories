%macro utl_encodeBase64(inp=,out=);
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
         data = open('&inp', 'rb').read();
         encoded = base64.b64encode(data);
         with open('&out', 'wb') as f:;
         .    f.write(encoded);
         ");
     %end;
%mend utl_encodeBase64;
