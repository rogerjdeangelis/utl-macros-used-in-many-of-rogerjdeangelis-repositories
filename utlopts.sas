%MACRO UTLOPTS
         / des = "Turn all debugging options off forgiving options";

OPTIONS
   MSGLEVEL=I
   OBS=MAX
   FIRSTOBS=1
   lrecl=384
   mautolocdisplay
   NOFMTERR      /* DO NOT FAIL ON MISSING FORMATS                              */
   SOURCE      /* turn sas source statements on                               */
   SOURCe2     /* turn sas source statements on                               */
   MACROGEN    /* turn  MACROGENERATON ON                                     */
   SYMBOLGEN   /* turn  SYMBOLGENERATION ON                                   */
   NOTES       /* turn  NOTES ON                                              */
   NOOVP       /* never overstike                                             */
   CMDMAC      /* turn  CMDMAC command macros on                              */
   /* ERRORS=2    turn  ERRORS=2  max of two errors                           */
   MLOGIC      /* turn  MLOGIC    macro logic                                 */
   MPRINT      /* turn  MPRINT    macro statements                            */
   MRECALL     /* turn  MRECALL   always recall                               */
   MERROR      /* turn  MERROR    show macro errors                           */
   NOCENTER    /* turn  NOCENTER  I do not like centering                     */
   DETAILS     /* turn  DETAILS   show details in dir window                  */
   SERROR      /* turn  SERROR    show unresolved macro refs                  */
   NONUMBER    /* turn  NONUMBER  do not number pages                         */
   FULLSTIMER  /*   turn  FULLSTIMER  give me all space/time stats            */
   NODATE      /* turn  NODATE      suppress date                             */
   /*DSOPTIONS=NOTE2ERR                                                                              */
   /*ERRORCHECK=STRICT /*  syntax-check mode when an error occurs in a LIBNAME or FILENAME statement */
   DKRICOND=WARN      /*  variable is missing from input data during a DROP=, KEEP=, or RENAME=     */
   DKROCOND=WARN      /*  variable is missing from output data during a DROP=, KEEP=, or RENAME=     */
   /* NO$SYNTAXCHECK  be careful with this one */
 ;

run;quit;

%MEND UTLOPTS;
