%macro utl_renamel ( old , new ) ;
    /* Take two cordinated lists &old and &new and  */
    /* return another list of corresponding pairs   */
    /* separated by equal sign for use in a rename  */
    /* statement or data set option.                */
    /*                                              */
    /*  usage:                                      */
    /*    rename = (%renamel(old=A B C, new=X Y Z)) */
    /*    rename %renamel(old=A B C, new=X Y Z);    */
    /*                                              */
    /* Ref: Ian Whitlock <whitloi1@westat.com>      */

    %local i u v warn ;
    %let warn = Warning: RENAMEL old and new lists ;
    %let i = 1 ;
    %let u = %scan ( &old , &i ) ;
    %let v = %scan ( &new , &i ) ;
    %do %while ( %quote(&u)^=%str() and %quote(&v)^=%str() ) ;
        &u = &v
        %let i = %eval ( &i + 1 ) ;
        %let u = %scan ( &old , &i ) ;
        %let v = %scan ( &new , &i ) ;
    %end ;

    %if (null&u ^= null&v) %then
        %put &warn do not have same number of elements. ;

%mend  utl_renamel ;
