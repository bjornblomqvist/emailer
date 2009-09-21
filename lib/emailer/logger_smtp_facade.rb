module Emailer

  class LoggerSmtpFacade < MockSmtpFacade

    def initialize(settings = {})
      @logger_settings = settings.clone
      @logger_settings.keys.each do |key|
        raise ArgumentError.new("invalid option, {"+key.to_s+" => "+@logger_settings[key].to_s+"}") unless 
        [:log_file, :use].include? key
      end
      raise ArgumentError.new(":log_file location is missing") unless @logger_settings[:log_file]
      settings.clear
      super
    end

    def open
      if  @logger_settings[:use]
        @logger_settings[:use].open do 
          super
        end
      else
        super
      end
    end

    # And save, don't send, write to a singel file
    def send_mail(options)
      super
      
      @logger_settings[:use].send_mail options if @logger_settings[:use]

      File.open(@logger_settings[:log_file],File::WRONLY|File::APPEND|File::CREAT) do |f|

        f.print "email.add {\n"
        options.each do |option|
          f.print "\t:"+option.first.to_s+" => \""+option.last.to_s+"\"\n" unless option.first == :body
        end
        f.print "\t:sent_at => \""+Time.now.to_s+"\"\n"
        f.print "\t:body => \""+options[:body].to_s+"\"\n"
        f.print "}\n"
      end
    end

  end
end