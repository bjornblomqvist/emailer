module Emailer

  class ToFileSmtpFacade < MockSmtpFacade

    def initialize(settings = {})
      @tofile_settings = settings.clone
      @tofile_settings.keys.each do |key|
        raise ArgumentError.new("invalid option, {"+key.to_s+" => "+@tofile_settings[key].to_s+"}") unless 
        [:file_dir, :use].include? key
      end
      raise ArgumentError.new(":log_file location is missing") unless @tofile_settings[:file_dir]
      @tofile_settings[:file_dir] = @tofile_settings[:file_dir].to_s
      settings.clear
      super
    end
    
    def open 
      if(@tofile_settings[:use]) 
        @tofile_settings[:use].open do 
          super
        end
      else
        super
      end
    end
    
    def send_mail options
      super
    
      @tofile_settings[:use].send_mail options if @tofile_settings[:use]
      
      options = options.clone
      
      options[:sent_at] = Time.now.to_s
      
      Dir.mkdir @tofile_settings[:file_dir] unless File.exist? @tofile_settings[:file_dir]
      
      file =  @tofile_settings[:file_dir]+"/"+"sent_at("+(options[:sent_at].gsub(" ","_"))+").to("+options[:to]+")"+".from("+options[:from]+").html"
      body_file =  "sent_at("+(options[:sent_at].gsub(" ","_"))+").to("+options[:to]+")"+".from("+options[:from]+")_body.html"
      latest_file = @tofile_settings[:file_dir]+"/"+"latest.html"
      
      head = ""
      body = options[:body] 
      
      options.each do |option|
        head += "<div class=\"label\">"+option.first.to_s.capitalize.gsub("_"," ")+":</div><div class=\"value\">"+option.last.to_s+"</div>\n" unless option.first == :body
      end
      
      
      
      if body.downcase.include? "<html>"
        body = %&<iframe src="#{body_file}"></iframe>&
        
        File.open(@tofile_settings[:file_dir]+"/"+body_file,File::WRONLY|File::CREAT) do |file| 
          file.print options[:body]
        end
      else
        body = "<pre>"+body+"</pre>"
      end
      
      
      toWrite = <<ANEWHTML
      <html>
        <head>
          <title>#{options[:subject]}</title>
          <style type="text/css">
            div.label {
              clear: left;
              float: left;
              width: 80px;
            }
            
            div.value {
              float: left;
            }
            
            div.head {
              background-color: #aaa;
              border-bottom: solid 1px;
              float: left;
              width: 100%;
            }
            
            div.head_inner {
              float: left;
              padding: 15px;
            }
            
            div.head_back {
              float: left;
            }
            
            
            body {
              padding: 0px;
              margin: 0px;
            }
            
            div.body {
              float: left;
              width: 100%;
              padding: 0px;
              margin: 0px;
            }
            
            iframe {
              width: 100%;
              height: 100%;
              border: none;
              padding: 0px;
              margin: 0px;
            }
          </style>
        </head>
        <body>
        <div class="head">
          <div class="head_inner">
            #{head}
          </div>
          <div class="head_back">
          <a href="index.html"><h1>Back &gt;&gt;</h1></a>
          </div>
        </div>
        <div class="body">
            #{body}
        </div>
        </body>
      </html>
ANEWHTML

      
      
      File.open(file,File::WRONLY|File::CREAT) do |f|
        f.print toWrite
      end
      
      File.unlink latest_file if File.exists? latest_file
      File.symlink file,latest_file
      
      createIndex
      
    end
    
    def createIndex
      
      index = @tofile_settings[:file_dir]+"/index.html"
      
      File.open(index,File::WRONLY|File::CREAT) do |f|
        
        links = ""
        
        counter = 0
        
        Dir.open(@tofile_settings[:file_dir]).sort.each do |fileName|
          if(fileName.index("sent_at") == 0 && fileName.index("_body") == nil)
            counter += 1
            links = %&<div class="number">#{counter}</div><div class="link #{counter % 2 == 0 ? "evan" : "odd"}"><a href="#{fileName}">#{fileName}</a></div>\n& + links
          end
        end
        
        f.print <<HTML
    
    <html>
      <head>
        <title></title>
        <style type="text/css">
          body {
            padding: 10px;
            margin: 0px;
            width: 900px;
            margin: auto;
          }
        
          div.number {
            float: left;
            clear: both;
            padding: 5px 10px;
            background-color: #aaa;
            border-right: solid 1px;
            width: 30px;
          }
          
          div.link {
            padding: 5px 10px;
            float: left;
            width: 800px;
          }
          
          a {
            color: black;
          }
          
          a:hover {
            text-decoration: none;
          }
          
          div.evan {
            background-color: #dddddd;
          }
          
          div.evan {
            background-color: #e5e5e5;
          }
          
          div.link:hover {
            background-color: yellow;
          }
          
        </style>
      </head>
      <body>
        #{links}
      </body>
    </html>    
        
HTML
        
      end
    end

  end
end