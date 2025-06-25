function sql_create_insert(db,dbtbl,sqltbl)
   sql_create_table(db,dbtbl,sqltbl);
   sql_insert      (db,dbtbl,sqltbl);
end;
