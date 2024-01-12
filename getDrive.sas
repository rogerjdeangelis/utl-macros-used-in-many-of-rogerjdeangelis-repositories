%macro getDrive(pth)/ des="Extract drive letter from the full path" ;
    %qscan(&pth,1,":");
%mend getDrive;
