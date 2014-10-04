require 'cuba'
require 'pg'

msg = "Received req"

connection_hash = {
                    dbname: 'lingodb',
                    user: 'lingouser',
                    password: 'lingopwd' 
                  }

conn = PG.connect(connection_hash)

#main_query = "SELECT * FROM pg_stat_activity"
main_query = "select schemaname, tablename, tableowner from pg_catalog.pg_tables limit 5"

query_result_filename = "out.txt"

c = %w(schemaname tablename tableowner)

Cuba.define do
  on root do
    res.write(msg)
    out_file = File.new(query_result_filename, "w")
    
    conn.exec(main_query) do |result|
      puts "creating txt file"
      result.each do |row|
        out_file.write(row.values_at(*c).push(" ~\n").join(" "))
      end
    end
    
    out_file.close

  end
end
