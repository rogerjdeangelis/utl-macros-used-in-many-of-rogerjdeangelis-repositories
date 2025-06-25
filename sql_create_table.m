function sql_create_table(db,inp,quoted_table);
  colnames = inp.Properties.VariableNames;
  ncols = numel(colnames);
  sqlcols = cell(1, ncols);
  for i = 1:ncols
    colname = colnames{i};
    coldata = inp.(colname);
    firstval = coldata(1);
    if iscell(firstval) && (ischar(firstval{1,1}) || isstring(firstval{1,1}))
        sqltype = "TEXT";
    else
        sqltype = "REAL";
    end
    sqlcols{i} = sprintf('%s %s', colname, sqltype);
  end
  sql_str = sprintf('( %s )', strjoin(sqlcols, ','));
  sql_make = ["create table ", quoted_table, sql_str];
  _temp_ = ["create table _temp_" sql_str];
  disp(sql_make)
  disp(_temp_)
  execute(db,sql_make);
  execute(db,_temp_);
end
