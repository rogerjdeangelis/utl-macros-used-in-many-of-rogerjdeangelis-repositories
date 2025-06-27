function matx=table2matx(tbl);
   ##################################################
   ##  dbtbl must have only numeric values         ##
   ##  might work for mixed or character sql table ##
   ##################################################
   [rows,cols]=size(tbl);
   mat = cell(rows,cols);
   for row=1:rows;
     for col=1:cols;
       mat(row,col)= tbl{row}{col};
     end;
   end;
   matx=cell2mat(mat);
end
