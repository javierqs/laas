require 'cuba'
require 'pg'

Cuba.define do
  on root do
    res.write("HI")
    out_file = 
File.new("out.txt", "w")
    conn = PG.connect( dbname: 'lingodb', user: 'lingouser', password: 
'lingopwd')
    conn.exec("SELECT * FROM pg_stat_activity") do |result|
      puts "creating txt file"
      #TODO verify why it creates a new line
      out_file.write(result.first.values_at('pid','usename').push(" 
~").join(" "))
      out_file.close
    end
  end
end
