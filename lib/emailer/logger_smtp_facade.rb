module Emailer
  
  class LoggerSmtpFacade < MockSmtpFacade
  
    # And save, don't send, write to a singel file
    def send_mail(options)
      super options
      
    end
  
  end
end