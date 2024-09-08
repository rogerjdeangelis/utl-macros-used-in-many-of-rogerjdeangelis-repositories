macro vdo_numvar(dsn)/des="Nnmber of variables in a SAS dataset";              
     %let dsid=%sysfunc(open(&dsn));%sysfunc(attrn(&dsid,nvars)) %let rc=%sysfunc(close(&dsid));                                                                
%mend vdo_numvar; 
