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
    
  end
end