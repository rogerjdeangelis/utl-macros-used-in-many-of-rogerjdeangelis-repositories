%MACRO greenbar ;
   DEFINE _row / order COMPUTED NOPRINT ;
   COMPUTE _row;
      nobs+1;
      _row = nobs;
      IF (MOD( _row,2 )=0) THEN
         CALL DEFINE( _ROW_,'STYLE',"STYLE={BACKGROUND=graydd}" );
   ENDCOMP;
%MEND greenbar;