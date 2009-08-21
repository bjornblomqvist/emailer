
module Emailer
  class AuthSmtpFacade < SmtpFacade
    
    def self.default_configuration
      {
        :host => 'mail.authsmtp.com',
        :port => 2525,
        :authentication => :cram_md5
      }
    end
        
    def initialize(settings)
      super AuthSmtpFacade.default_configuration.merge(settings)
    end
    
  end
end