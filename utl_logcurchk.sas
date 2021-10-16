
/*=====================================================================================*
Program Language    :  SAS V9.1.3  or later
Operating System    :  Win 10 64 bit
________________________________________________________________________________________

You need the Classic 1980s SAS Editor for this log check.

This will not work in EE, EG, SAS Studio, University edition..., On Daemand ...

Purpose             : Check log

Run Dependencies    : Requires interactive SAS and classic editor

Sample call         : %utl_logcurchk

Macro Calls

  Internal          : utl_logcurchk

Files

  Input             : .SAS Interactive log window

  Output            :  SAS Interative Output window

  Function key      : PF7: log;file "pgm.log" r;note zx;notesubmit '%utl_logcurchk;';
                      Saves the log in the present working directory as pgg.log

Program Flow        :

     1.             Function key PF7 Saves the log in the present working directory as pgg.log
     2.             Read log and check for error, note, warning, chop lines, perm sas datasets and fileI/O
     3.             Post suumar of log in the interactive output window

========================================================================================*/

%macro utl_logcurchk;

    %local _pth;

    * problematic keywords;

    %macro ary;
     Array Notes{328} $64 (
         " 0 observations rewritten, 0 observations added and 0 observations deleted"
         " 0 lines"
         " 0 observations"
         " 0 records"
         " 0 rows"
         " 0 obs"
         "%to value of"
         "traceback"
         "not currently in"
         "abnormally terminated"
         "access denied"
         "allowed"
         "already been defined"
         "ambiguous"
         "apparent invocation"
         "apparent symbolic"
         "appears as text"
         "are not allowed"
         "argument 1"
         "argument 2"
         "argument 3"
         "assumed"
         "assuming"
         "at least"
         "but appears on"
         "but is not"
         "but no"
         "by-group"
         "cannot be accessed"
         "cannot be deleted"
         "cannot be found"
         "cannot be loaded"
         "cannot be"
         "cannot open"
         "cartesian"
         "central parameter"
         "character in one"
         "clause has been augmented"
         "clause references"
         "cli error"
         "closing"
         "columns were too wide"
         "condition in the"
         "conflicting attributes"
         "contain no data in common"
         "contain unequal"
         "contains 1 variable"
         "convert"
         "converted to"
         "converted"
         "could not be fit"
         "could not be found"
         "could not be loaded"
         "could not be written"
         "could not be"
         "could not"
         "creates a common"
         "default estimation"
         "default style will be used instead"
         "defined as both"
         "did not satisfy"
         "differ"
         "different data types"
         "division by zero"
         "denied"
         "does not exist"
         "does not have enough arguments"
         "does not match"
         "doesn't appear"
         "doesn't have"
         "double-dash"
         "due to a"
         "due to errors"
         "due to looping"
         "dummy macro"
         "ellipsoid centered"
         "end of macro"
         "end-of-record"
         "ending execution"
         "enter run"
         "error"
         "errorabend"
         "errorcheck=strict"
         "errors noted"
         "estimated autoregression parameter"
         "examine fields"
         "exceed"
         "exceeds 8 characters"
         "execution terminated"
         "execution terminating"
         "expected"
         "expecting"
         "experimental release"
         "export cancelled"
         "expression has no"
         "extraneous information"
         "extraneous"
         "failed to converge"
         "failed to load"
         "failed to"
         "fatal"
         "firstobs option >"
         "firstobs option"
         "generic critical"
         "groups are not created"
         "hanging"
         "has 0 observations"
         "has _type_"
         "has a null"
         "has already been defined"
         "has already been set"
         "has already been"
         "has already"
         "has become more"
         "has been reduced"
         "has been transformed"
         "has been discarded"
         "has changed"
         "has different lengths"
         "has exceeded"
         "has multiple"
         "has never been"
         "has no condition"
         "has not been dropped"
         "has not been"
         "has too few"
         "have been detected"
         "ignored"
         "ignoring"
         "illegal"
         "included in the"
         "incomplete"
         "incorrect"
         "input data set is empty"
         "input distances have been squared"
         "input data set is already sorted"
         "input empty"
         "insufficient"
         "invalid"
         "is already on the"
         "is already sorted"
         "is also a dataset"
         "is ambiguous"
         "is before the starting"
         "is included"
         "is invalid"
         "is less than or equal"
         "is less than"
         "is not a valid"
         "is not allowed"
         "is not assigned"
         "is not greater than"
         "is not in effect"
         "is not in"
         "is not on file"
         "is not recognized"
         "is not sorted"
         "is not valid"
         "is obsolete"
         "is sequential"
         "it is used out"
         "is obsolete"
         "labels differ"
         "length of numeric"
         "limit set by"
         "list empty"
         "lost card"
         "mathemat"
         "mathematical operations"
         "may be incomplete"
         "may be longer"
         "may not be as expected"
         "merge statement has more than"
         "merge statement"
         "missing close parentheses"
         "missing equals sign"
         "missing on every"
         "missing semicolon"
         "missing values"
         "missing"
         "misspelled"
         "mixed engine types"
         "model contains"
         "more positional"
         "multiple lengths"
         "multiple optimal"
         "multiple vertical"
         "multiple"
         "must be character"
         "must be entered"
         "must be followed"
         "must be given"
         "must be invoked"
         "must have appeared"
         "must precede"
         "no body file"
         "no body"
         "no by"
         "no cards"
         "no data set"
         "no data sets qualify"
         "no data"
         "no effect"
         "no expression"
         "no file"
         "no formats found"
         "no keep"
         "no libraries"
         "suppress"
         "no logical"
         "no longer exists"
         "no matching"
         "no non-missing"
         "no observations"
         "no output destinations active"
         "no output produced"
         "no output"
         "no rows were selected"
         "no rows"
         "no shape"
         "no variables found"
         "no variables specified"
         "no variables"
         "none of the options"
         "not a valid"
         "not acceptable"
         "not adjusted"
         "not all"
         "not allow character"
         "not be included"
         "not be performed"
         "not currently licensed"
         "not found"
         "not in a valid"
         "not in effect"
         "not licensed"
         "not on input data set"
         "not processed"
         "not recognized"
         "not replaced because"
         "not resolved"
         "not valid for import"
         "not valid"
         "not written"
         "null where"
         "numeric in one"
         "obs=0"
         "observations not"
         "obsolete"
         " omitted due to"
         "occurred on module"
         "offline"
         "one or more lines may be longer"
         "operand was found in"
         "option value"
         "outside the axis"
         "parenthesis for"
         "previous errors"
         "proc sql statements are executed immediately"
         "product not found"
         "product with which"
         "partial initialization"
         "quoted string"
         "recursion"
         "recursive"
         "reference"
         "references the data set being updated"
         "refers to the same"
         "refers to"
         "repeat"
         "request ignored"
         "required operator not found"
         "requires a numeric"
         "requires compatible"
         "right-hand"
         "sas set option obs=0"
         "sas went"
         "scale parameter was held fixed"
         "shifted"
         "starting variable"
         "statement has been deleted"
         "statement needs"
         "statement syntax"
         "statement transforms"
         "statistics are mean corrected"
         "statistics requested"
         "stop"
         "stopped"
         "subroutine"
         "syntax for this"
         "the chi-square is small"
         "too long"
         "too many array subscripts"
         "too small"
         "too wide"
         "trying to use"
         "unable to initialize"
         "unable to"
         "unable"
         "unbalanced"
         "unclosed"
         "undeclared"
         "undetermined"
         "uninitialized"
         "unknown"
         "unrecognized"
         "unref"
         "unresolved"
         "unsatisfied"
         "violation"
         "was disabled"
         "was stopped"
         "was misspelled as"
         "was not created"
         "was not defined"
         "was not found"
         "was not replaced"
         "went to a new line"
         "were excluded"
         "will be assumed"
         "will be used"
         "will not be"
         "will not load"
         "will stop executing"
         "within the range"
         "you can only"
         "your request"
         "zero elements" );
       %mend ary;

       filename _pwd "pgm.log";
       %let _pth=%sysfunc(pathname(_pwd));
       %put xxxxxxx &_pth xxxxxxxxx;

       Data Q_A(keep=question answer);
        Length Question $16 Answer $255 infile $255;
        /*---------------------------------------------*\
        |  Read Log and Count Errors and Warnings       |
        \*---------------------------------------------*/
        infile "pgm.log" length=ll0 end=done;
          input;
          If _n_=1 then do;
             Question='LOG';
             Answer="&_pth";
             output;
             Question="SCRUB_TIME";
             dte=datepart(datetime());
             wek=put(dte,weekdate.);
             tym=put(timepart(datetime()),time5.);
             answer=catx(' ',tym,wek);
             Output;
          end;
         /*---------------------------------------------*\
         |  Input and Output files                       |
         \*---------------------------------------------*/
          answer=_infile_;
          infile=lowcase(left(_infile_));
          if index(infile,'were written to file' ) gt 0  or
             index(infile,'written to'           ) gt 0  or
             index(infile,'lines written to file') gt 0  or
             index(infile,'file name='           ) gt 0  or
             index(infile,'libname'              ) gt 0  or
             index(infile,'filename'             ) gt 0  or
             index(infile,'physical file'        ) gt 0  or
             index(infile,'file:'                ) gt 0  then do;question="FILE_IO";output;end;
              /*---------------------------------------------*\
              |  Errors Warnings Notes and Chop               |
              \*---------------------------------------------*/
             Select;
                 When (substr(left(infile),1,5) ='error'
                       or index(infile,'error:')>0)       Do; question="%str(ERR)OR";answer=_infile_; Output; End;
                 When (substr(left(infile),1,4)='note')   Do;
                      %ary;
                      question="NOTES";
                      Do i=1 to dim(Notes) ;
                        if index(strip(infile),trim(Notes{i})) > 0 then output;
                      End;
                 End;
                 When (substr(left(infile),1,7)='warning')                    Do;question="WARNING";output;end;
                 When (index(infile,'warning')>0 or index(infile,'error')>0)  Do;question="CHOP";output;end;
                 Otherwise;
             end;
              /*---------------------------------------------*\
              |  Examine Permanent SAS Tables                 |
              \*---------------------------------------------*/

             if substr(left(infile),1,4)='note' then do;
                 question="DATASETS";
                 put "XXXXXXXXXXXXXXXXXXX    " infile "XXXXXXX  ";
                 select;
                   when (substr(infile,7,5)  eq 'table'       ) do; put infile; output; end;
                   when (substr(infile,7,12) eq 'the data set') do; put infile; output; end;
                   otherwise ;
                 end;
             end;
     run;

    proc format;
     invalue que2odr
     'LOG'   = -20
     'SCRUB_TIME' = -10
     "%str(ERR)OR"= 4
     'WARNING'    = 5
     'NOTES'      = 6
     'DATASETS'   = 7
     'FILE_IO'    = 9
     'OPTIONS'    = 8;
    run;quit;

    data shl;
      length question $16 answer $255;
      question='LOG     '   ;answer='remove';output;
      question='SCRUB_TIME' ;answer='remove';output;
      question="%str(ERR)OR";answer='remove';output;
      question='WARNING'    ;answer='remove';output;
      question='NOTES'      ;answer='remove';output;
      question='DATASETS'   ;answer='remove';output;
      question='FILE_IO'    ;answer='remove';output;
      question='OPTIONS'    ;answer='remove';output;
    run;

    proc sql;
      create
         table shlful as
      select
         distinct
          coalesce(r.question,l.question) as question length=16
         ,coalesce(r.answer,l.answer)     as answer   length=255
         ,case when r.answer='' then 0 else 1 end as flg
      from
          shl as l left join q_a(where=(
           not ( lowcase(answer) contains ("is in a format native")                    or
                 lowcase(answer) contains ('note: multiple concurrent threads')        or
                 lowcase(answer) contains ('refers to the same physical')              or
                 lowcase(answer) contains ("data file is being copied to base file")   or
                 lowcase(answer) contains ('created, with 0 rows and')                 or
                 lowcase(answer) contains ('warn    =')
               ))) as r
      on
          l.question=r.question
    ;
    quit;

    proc sql;
      create
         table typodr(where=(not (answer='remove'))) as
      select
        input(question,que2odr.)-8  as odr
        ,question
        ,put(sum(flg),4. -l) as answer
      from
         shlful
      where
         question not in ('LOG' 'SCRUB_TIME')
      group
         by calculated odr, question
      outer union corr
      select
        input(question,que2odr.)  as odr
        ,question
        ,left(answer) as answer
      from
         shlful
      order
         by odr, question;
    quit;


    data _null_;

     file print;

     retain str '----------------------------------------------------------------------------------------------------------------------';
     set typodr;

     by question notsorted;

     answer=left(answer);
     if _n_=1 then put str;
     if odr>1 and first.question then put str;
     put question  @12 answer;

    run;

%mend utl_logcurchk;
