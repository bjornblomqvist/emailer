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
      @sent = []
      super
    end
    
    # Don't open connections...
    def get_net_smtp_instance
      MockNetSmtp.new
    end
    
    # And save, don't send, mail...
    def send_mail(options)
      raise ConnectionNotOpenError unless @open
      @sent << options
      true
    rescue ConnectionNotOpenError => e
      raise e
    rescue StandardError => e
      @error = e
      @offending_mail = mail
      false
    end
    
  end
end
