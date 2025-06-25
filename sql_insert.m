function sql_insert(db,inp,out);
   sql_delete = sprintf('DELETE FROM %s;', out);
   execute(db,sql_delete)
   columns = inp.Properties.VariableNames;
   n_rows  = size(inp, 1);
   % Construct and execute INSERT for each row
      for i = 1:n_rows
          % Get values for the current row
          values = cell(1, length(columns));
          for j = 1:length(columns)
              col_data = inp.(columns{j});
              if iscell(col_data)
                  values{j} = col_data{i};   % Handle text fields
              else
                  values{j} = col_data(i);   % Handle numeric fields
              end
          end
          formatted_values = cell(1, length(values));
          for k = 1:length(values)
              if ischar(values{k})
                  % Escape single quotes and wrap in SQL quotes
                  escaped_str = strrep(values{k}, "'", "''");
                  formatted_values{k} = sprintf("'%s'", escaped_str);
              else
                  formatted_values{k} = num2str(values{k});  % Convert numbers to strings
              end
          end
          % Build the INSERT query safely
          col_list = strjoin(columns, ', ');
          val_list = strjoin(formatted_values, ', ');
          query = sprintf('INSERT INTO %s (%s) VALUES (%s)',out, col_list, val_list);
          execute(db, query);
      end
      disp(query);
end
