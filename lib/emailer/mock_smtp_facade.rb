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
      @count = Time.now.to_i
      super
    end

    # Don't open connections...
    def get_net_smtp_instance
      MockNetSmtp.new
    end

    # And save, don't send, mail...
    def send_mail(options)
      raise ConnectionNotOpenError unless @open
      @sent[@count.to_s] = options
      @count += 1
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
      TestingMiddleware.testing_path+uuidString
    end
  end

end

