require 'tmail'
require 'net/smtp'

module Emailer
  
  class MailerError < RuntimeError; end
  class ConnectionNotOpenError < MailerError; end
  
  class SmtpFacade
    attr_reader :settings, :error, :offending_mail
    
    def initialize(settings)
      @settings = settings
      @settings.keys.each do |key|
        raise ArgumentError unless [
            :host, :port, :username, :password, :authentication, :domain
          ].include?(key)
      end
    end
    
    def open
      @open = true
      open_connection
      yield
    ensure
      @open = false
      close_connection
    end
    
    def get_net_smtp_instance
      Net::SMTP.new settings[:host], settings[:port]
    end
    
    ##
    # Sends a mail to the represented SMTP server. Options is expected to include
    # :to, :from, :subject, :body, :content_type and :encoding. Use send_html or
    # send_text to provide defaults for :content_type and :encoding.
    #
    def send_mail(options)
      raise ConnectionNotOpenError unless @open
      
      content_type_args = options[:content_type].split('/') << { 'charset' => options[:encoding] }
      
      mail = TMail::Mail.new
      mail.set_content_type *content_type_args
      mail.to = options[:to]
      mail.from = options[:from]
      mail.subject = options[:subject]
      mail.body = options[:body]

      @connection.sendmail(mail.encoded, mail.from[0], mail.destinations)
      true
    rescue ConnectionNotOpenError => e
      raise e
    rescue StandardError => e
      @error = e
      @offending_mail = mail
      close_connection
      false
    end
    
    def send_html(options)
      send_mail(options.merge(:content_type => 'text/html', :encoding => 'utf-8'))
    end
    
    def send_text(options)
      send_mail(options.merge(:content_type => 'text/plain', :encoding => 'utf-8'))
    end
    
    private
    def open_connection
      @connection = get_net_smtp_instance
      @connection.start(
        settings[:domain], 
        settings[:username],
        settings[:password],
        settings[:authentication]
      )
    end
    
    def close_connection
      @connection.finish if @connection
      @connection = @open = nil
    end
    
  end
end
