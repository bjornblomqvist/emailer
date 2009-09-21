require 'uuid'

module Emailer
  
  class MockNetSmtp
    def start(*args); end
    def sendmail(*args); end
    def finish; end
    def started?; end
  end
  
  class MockSmtpFacade < SmtpFacade
  
    attr_reader :sent
    
    def initialize(settings = {})
      @sent = {}
      super
    end
    
    # Don't open connections...
    def get_net_smtp_instance
      MockNetSmtp.new
    end
    
    # And save, don't send, mail...
    def send_mail(options)
      raise ConnectionNotOpenError unless @open
      @sent[UUID.new.generate] = options
      true
    rescue ConnectionNotOpenError => e
      raise e
    rescue StandardError => e
      @error = e
      @offending_mail = options
      false
    end
    
    def last_email_sent
      @sent[@sent.keys.last.to_s]
    end
    
    def last_email_sent_key
      @sent.keys.last
    end
    
    def last_email_sent_url
      get_url_for last_email_sent_key
    end
    
    def get_url_for uuidString
      return "/getemail/"+uuidString
    end
  end
  
  class TestingMiddleware
    
    def call(env)
      if  env["PATH_INFO"].index("/getemail/")

        uuid = env["PATH_INFO"].sub("/getemail/".length)
        
        return [200, {"Content-Type" => "text/plain"},['Emailer::SmtpFacade.default is not a MockSmtpFacade']] unless
          Emailer::SmtpFacade.default.instance_of? Emailer::MockSmtpFacade 
        
        return [200, {"Content-Type" => "text/plain"},['No email sent']] if Emailer::SmtpFacade.default.sent.count == 0
        
        return [200, {"Content-Type" => "text/html"}, [Emailer::SmtpFacade.default.sent[uuid][:body].to_s]]
      else
        @app.call env
      end
    end
    
  end
end


