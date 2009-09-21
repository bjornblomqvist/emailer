require File.join(File.dirname(__FILE__), "../spec_helper")

module Emailer
  describe MockSmtpFacade do
    
    describe :initialize do
      it "Should be able to send without actulay sending anything" do
        
        message = {:to => "test@bits2life.com",
        :from => "test@bits2life.com",
        :subject => "A test",
        :body => "A test body"}
        
        smtp = MockSmtpFacade.new
        
        smtp.open do
          smtp.send_mail(
            message
          )
        end
        
        smtp.last_email_sent.should == message
        
      end
    end
  
     describe :last_email_sent_url do
        it 'Should return url to last email sent' do
            smtp = MockSmtpFacade.new

            email = { 
              :to => "test@bits2life.com",
              :from => "test2@bits2life.com",
              :subject => "This is a test 4",
              :body => "Test body"
            }

            smtp.open do
              smtp.send_mail email
            end

            smtp.last_email_sent_url.should ==  TestingMiddleware.testing_path+smtp.sent.keys.last
        end
      end
    
  end
  
end