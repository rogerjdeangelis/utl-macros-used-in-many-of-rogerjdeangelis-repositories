%macro utl_ci(
       Mid
      ,Lwr
      ,Upr
      ,LwrUpr_format=4.1
      ,mid_format=&LwrUpr_format
      )
   / des="standard confidence interval formatting";
      compbl(put(&Mid,&mid_format -l)
       !!' ('
       !!compress(put(&Lwr,&LwrUpr_format -l)
       !!',')
       !!' '
       !!put(&Upr,&LwrUpr_format -r)
       !!')')
%mend utl_ci;
