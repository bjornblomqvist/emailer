module Emailer
  
  
  class TestingMiddleware
    
    class << self
      attr_accessor :testing_path 
      def testing_path 
        @testing_path ||= "/get_email_just_for_test/"
      end
    end
    
    
    def initialize(app)
      @app = app
    end
    
    def call(env)
      if  env["PATH_INFO"].index(TestingMiddleware.testing_path)

        uuid = env["PATH_INFO"][TestingMiddleware.testing_path.length..-1]
        
        return [200, {"Content-Type" => "text/plain"},['Emailer::SmtpFacade.default is not a MockSmtpFacade']] unless
          Emailer::SmtpFacade.default.instance_of? Emailer::MockSmtpFacade 
        
        return [200, {"Content-Type" => "text/plain"},['No email sent']] unless Emailer::SmtpFacade.default.sent.count > 0
        
        return [200, {"Content-Type" => "text/plain"},['No email with that ID']] unless Emailer::SmtpFacade.default.sent[uuid]
        
        return [200, {"Content-Type" => "text/html"}, [Emailer::SmtpFacade.default.sent[uuid][:body].to_s]]
      end
      
      @app.call env
    end
    
  end
  
end