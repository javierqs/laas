require 'cuba'
require 'cuba/render'
require 'erb'
#require 'sequel'
#require 'pg'

Cuba.plugin Cuba::Render

Cuba.use Rack::Static,
  root: 'public',
  urls: ['/css']

connection_hash = {
                    dbname: 'lingodb',
                    user: 'lingouser',
                    password: 'lingopwd' 
                  }

#Sequel::Model.plugin(:schema)
#DB = Sequel.postgres()

#conn = PG.connect(connection_hash)

class Model

end

@set_name = "TASKS"
@set_attributes = " TIME, ES, LS, SLACK"

@table_columns = "TASKS"
@current_file_name = "session_n1"



Cuba.define do
  on root do
    res.write view('home')
=begin
    out_file = File.new(query_result_filename, "w")
    lingo_script_file = File.new(lingo_script_filename, "w")

    conn.exec(main_query) do |result|
      puts "creating txt file"
      result.each do |row|
        out_file.write(row.values_at(*c).push(" ~\n").join(" "))
      end
    end
    
    out_file.close
    source = File.expand_path("/home/j/laas/templates/lingo_script.lng")

    lingo_script_file.write(ERB.new(::File.binread(source)).result)
    lingo_script_file.close
=end
  end

  on 'models' do
    on get do
      on "test" do
        res.write view('test')
      end

      on ":name" do |name|
        res.write view('show', name: name)
      end
    end

    on post do
      on "test_output", param('model') do |model|
        test_file_name = "test_one"
        test_file = File.new(test_file_name + ".ltf", "w")
        test_file.write(model["script"])
        test_file.write("\nSET TERSEO 3\nGO\n\DIVERT output_#{test_file_name}.txt\nSOLUTION\nRVRT\nQUIT")
        test_file.close 
        output = `../lingo14/bin/linux64/lingo64_14 < test_one.ltf`
        @content = File.read("output_test_one.txt")
        if req.xhr?
          res.write partial('test_ajax',content: @content)
        else
          res.write view('test_output', content: @content)
        end
      end

      on ":name/process", param('model') do |name, params|
        res.write "1 #{name} 2 #{params}"
        #res.write File.read(File.expand_path("/home/j/laas/lingoout.txt"))
        # guardar sets
        # guardar data
        # guardar constraints
        # obtener sets, data, constraints
        # generar txt con data
        # generar ltf
        # ejecutar ltf
        # generar resultado
        # mostrar 
      end
 
      on param('model') do |params|
        #model = Model.new params
        if !params["name"].empty?
          res.redirect "/models/#{params['name']}"
        else 
          res.redirect "/"
        end
      end
    end
  end

end
