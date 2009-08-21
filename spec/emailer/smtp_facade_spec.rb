require File.join(File.dirname(__FILE__), "../spec_helper")

module Emailer
  describe SmtpFacade do
    
    MAIL_OPTIONS = {
        :from => 'from@email.com',
        :to => 'to@email.com',
        :subject => 'subject',
        :body => 'body',
        :content_type => 'text/plain',
        :encoding => 'utf-8'
      }
    SMTP_OPTIONS = {
        :host => 'smtp.host.com',
        :port => 25,
        :username => 'username',
        :password => 'password',
        :authentication => :cram_md5,
        :domain => 'www.domain.com'
      }
      
      
    describe :initialize do
      it "should accept only known options" do
        lambda do
          SmtpFacade.new :foobar => 'fail'
        end.should raise_error
      end
      
      it "should accept all known options" do
        SmtpFacade.new SMTP_OPTIONS
      end
    end
    
    describe :clone do
      it "should return an instance with the same settings" do
        one = SmtpFacade.new SMTP_OPTIONS
        two = one.clone
        
        two.settings.should == one.settings
      end
      it "should not return the same instance" do
        one = SmtpFacade.new SMTP_OPTIONS
        two = one.clone
        
        two.should_not == one
      end
    end
    
    context "given an SMTP server's settings" do
      before(:each) do
        @smtp = SmtpFacade.new SMTP_OPTIONS
      end
      
      it "should remember these settings" do
        smtp = SmtpFacade.new SMTP_OPTIONS
        smtp.settings[:port].should == 25
        smtp.settings[:username].should == 'username'
      end
      
      describe :get_net_smtp_instance do
        it "should use :host and :port to initialize connection" do
          Net::SMTP.should_receive(:new).with('smtp.host.com', 25).and_return nil
          @smtp.get_net_smtp_instance
        end
      end
      
      describe :open do
        before(:each) do
          @netsmtp = mock('net_smtp').as_null_object
          @smtp.stub!(:get_net_smtp_instance).and_return @netsmtp
        end
        
        it "should get a connection using :get_net_smtp_instance" do
          @smtp.should_receive(:get_net_smtp_instance).and_return @netsmtp
          @smtp.open do
          end
        end
        
        it "should initialize the connection and authenticate" do
          @netsmtp.should_receive(:start).with('www.domain.com', 'username', 'password', :cram_md5)
          @smtp.open do
          end
        end
        
        it "should close this connection after the block is finished" do
          @netsmtp.should_receive(:finish)
          @smtp.open do
          end
        end
      end
      
      describe :send_mail do
        it "should raise an ConnectionNotOpenError unless we're inside :open" do
          lambda do
            @smtp.send_mail({})
          end.should raise_error(ConnectionNotOpenError)
        end
        
        it "should send the mail to the opened connection" do
          @netsmtp = mock('net_smtp').as_null_object
          @smtp.should_receive(:get_net_smtp_instance).and_return @netsmtp
          @netsmtp.should_receive(:sendmail).once
          
          @smtp.open do
            @smtp.send_mail(MAIL_OPTIONS)
          end
        end
        
        it "should close the connection if it encounters an error" do
          @netsmtp = mock('net_smtp').as_null_object
          @smtp.should_receive(:get_net_smtp_instance).and_return @netsmtp
          @netsmtp.should_receive(:sendmail).once.and_raise(StandardError)
          
          lambda do
            @smtp.open do
              2.times do
                @smtp.send_mail(MAIL_OPTIONS).should be_false
              end
            end
          end.should raise_error(ConnectionNotOpenError)
        end
      end
      
      describe :send_text do
        it "should delegate to :send_mail with :content_type => 'text/plain' and :encoding => 'utf-8'" do
          @netsmtp = mock('net_smtp').as_null_object
          @smtp.should_receive(:get_net_smtp_instance).and_return @netsmtp
          
          @smtp.should_receive(:send_mail).once.with(MAIL_OPTIONS.merge(
              :content_type => 'text/plain',
              :encoding => 'utf-8'
            ))
          @smtp.open do
            @smtp.send_text MAIL_OPTIONS.reject { |k, _| [:content_type, :encoding].include?(k) }
          end
        end
      end
      
      describe :send_html do
        it "should delegate to :send_mail with :content_type => 'text/html' and :encoding => 'utf-8'" do
          @netsmtp = mock('net_smtp').as_null_object
          @smtp.should_receive(:get_net_smtp_instance).and_return @netsmtp
          
          @smtp.should_receive(:send_mail).once.with(MAIL_OPTIONS.merge(
              :content_type => 'text/html',
              :encoding => 'utf-8'
            ))
          @smtp.open do
            @smtp.send_html MAIL_OPTIONS.reject { |k, _| [:content_type, :encoding].include?(k) }
          end
        end
      end
      
    end
  end
end
