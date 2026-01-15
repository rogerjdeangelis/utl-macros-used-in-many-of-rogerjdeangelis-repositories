import pyarrow.feather as feather                                               
import tempfile                                                                 
import pyperclip                                                                
import os                                                                       
import sys                                                                      
import subprocess                                                               
import time                                                                     
import pandas as pd                                                             
import pyreadstat as ps                                                         
import numpy as np                                                              
from pandasql import sqldf                                                      
mysql = lambda q: sqldf(q, globals())                                           
from pandasql import PandaSQL                                                   
pdsql = PandaSQL(persist=True)                                                  
sqlite3conn = next(pdsql.conn.gen).connection.connection                        
sqlite3conn.enable_load_extension(True)                                         
sqlite3conn.load_extension('c:/temp/libsqlitefunctions.dll')                    
mysql = lambda q: sqldf(q, globals())                                           
def fn_tosas9x(df,outlib="d:/sd1/",outdsn="txm",timeest=3):                     
    pthsd1  = outlib + outdsn + ".sas7bdat"                                     
    fthout  = outlib + outdsn + ".feather"                                      
    statcmd = outlib + "statcmd.stcmd"                                          
    if os.path.exists(pthsd1):                                                  
       os.remove(pthsd1)                                                        
    if os.path.exists(fthout):                                                  
       os.remove(fthout)                                                        
    if os.path.exists(statcmd):                                                 
       os.remove(statcmd)                                                       
    feather.write_feather(df,fthout,version=1)                                  
    f = open(statcmd, "a")                                                      
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
    ,"\ncopy " + fthout + " sas9 " + pthsd1 ])                                  
    f.close()                                                                   
    cmds="c:/PROGRA~1/StatTransfer17-64/st.exe " + outlib + "statcmd.stcmd"     
    devnull = open('NUL', 'w');                                                 
    rc = subprocess.Popen(cmds, stdout=devnull, stderr=devnull)                 
    time.sleep(timeest)                                                         
    os.system(f"taskkill /f /im {'st.exe'}")                                    
