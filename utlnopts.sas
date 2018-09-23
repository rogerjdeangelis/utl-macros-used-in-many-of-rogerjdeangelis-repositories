%macro utlnopts(note2err=nonote2err,nonotes=nonotes)
    / des = "Turn  debugging options off";

OPTIONS
     FIRSTOBS=1
     NONUMBER
     MLOGICNEST
   /*  MCOMPILENOTE */
     MPRINTNEST
     lrecl=384
     MAUTOLOCDISPLAY
     NOFMTERR     /* turn  Format Error off                           */
     NOMACROGEN   /* turn  MACROGENERATON off                         */
     NOSYMBOLGEN  /* turn  SYMBOLGENERATION off                       */
     &NONOTES     /* turn  NOTES off                                  */
     NOOVP        /* never overstike                                  */
     NOCMDMAC     /* turn  CMDMAC command macros on                   */
     NOSOURCE    /* turn  source off * are you sure?                 */
     NOSOURCE2    /* turn  SOURCE2   show gererated source off        */
     NOMLOGIC     /* turn  MLOGIC    macro logic off                  */
     NOMPRINT     /* turn  MPRINT    macro statements off             */
     NOCENTER     /* turn  NOCENTER  I do not like centering          */
     NOMTRACE     /* turn  MTRACE    macro tracing                    */
     NOSERROR     /* turn  SERROR    show unresolved macro refs       */
     NOMERROR     /* turn  MERROR    show macro errors                */
     OBS=MAX      /* turn  max obs on                                 */
     NOFULLSTIMER /* turn  FULLSTIMER  give me all space/time stats   */
     NODATE       /* turn  NODATE      suppress date                  */
     DSOPTIONS=&NOTE2ERR
     ERRORCHECK=STRICT /*  syntax-check mode when an error occurs in a LIBNAME or FILENAME statement */
     DKRICOND=ERROR    /*  variable is missing from input data during a DROP=, KEEP=, or RENAME=     */

     /* NO$SYNTAXCHECK  be careful with this one */
;

RUN;quit;

%MEND UTLNOPTS;
