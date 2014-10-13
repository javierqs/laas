require 'cuba'
require 'cuba/render'
require 'tilt/erb'
require 'open3'

Cuba.plugin Cuba::Render

Cuba.use Rack::Static,
  root: 'public',
  urls: ['/css']

connection_hash = {
                    dbname: 'lingodb',
                    user: 'lingouser',
                    password: 'lingopwd' 
                  }

Cuba.define do
  
  on root do
    res.write view('home')
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
        cmd = "$HOME/lingo14/bin/linux64/lingo64_14 < test_one.ltf"
        i, o, e, w = Open3.popen3(cmd)
        buf = ""
        error = false
        until o.eof? or error do
          buf << o.read_nonblock(50)
          if buf[-50..-1].include?(" ?"*24) or buf[-50..-1].include?(" :"*24)
            Process.kill 9, w.pid
            error = true
          end
        end
       
        if error
          @content = ["Script may have errors"]
        else
          @content = File.read("output_test_one.txt")
        end

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
