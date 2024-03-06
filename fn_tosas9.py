def fn_tosas9(dataf,dfstr="location",timeest=0 ):
   pthsav = "c:/temp/" + dfstr + ".sav"
   pthsd1 = "c:/temp/" + dfstr + ".sas7bdat"
   statcmd= "c:/temp/statcmd.stcmd"
   if os.path.exists(pthsav):
       os.remove(pthsav)
   else:
       print("The file does not exist")
   if os.path.exists(statcmd):
       os.remove(statcmd)
   else:
       print("The file does not exist")
   if os.path.exists(pthsd1):
       os.remove(pthsd1)
   else:
       print("The file does not exist")
   ps.write_sav(dataf, (pthsav))
   f = open("c:/temp/statcmd.stcmd", "a");
   f.writelines([
    "set numeric-names        n                "
   ,"\nset log-level          e                "
   ,"\nset in-encoding        system           "
   ,"\nset out-encoding       system           "
   ,"\nset enc-errors         sub              "
   ,"\nset enc-sub-char       _                "
   ,"\nset enc-error-limit    100              "
   ,"\nset var-case-ci        preserve-always  "
   ,"\nset preserve-label-sets y               "
   ,"\nset preserve-str-widths n               "
   ,"\nset preserve-num-widths n               "
   ,"\nset recs-to-optimize   all              "
   ,"\nset map-miss-with-labs n                "
   ,"\nset user-miss          all              "
   ,"\nset map-user-miss      n                "
   ,"\nset sas-date-fmt       mmddyy           "
   ,"\nset sas-time-fmt       time             "
   ,"\nset sas-datetime-fmt   datetime         "
   ,"\nset write-file-label   none             "
   ,"\nset write-sas-fmts     n                "
   ,"\nset sas-outrep         windows_64       "
   ,"\nset write-old-ver      1                "
   ,"\ncopy " + pthsav + " sas9 " + pthsd1 ])
   f.close()
   cmds="c:/PROGRA~1/StatTransfer16-64/st.exe c:/temp/statcmd.stcmd"
   devnull = open('NUL', 'w');
   rc = subprocess.Popen(cmds, stdout=devnull, stderr=devnull)
   time.sleep(timeest)
   os.system(f"taskkill /f /im {'st.exe'}")
