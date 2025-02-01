%macro sqlpartitionx(dsn,by=team)/
   des="Improved sqlpartition that maintains data order";
 ( select
     *
     ,max(seq) as seq
   from
     (select
        *
       ,seq-min(seq) + 1 as partition
     from
       (select *, monotonic() as seq from sd1.have)
     group
       by team )
   group
       by team, seq
   having
       1=1)
%mend sqlpartitionx;
