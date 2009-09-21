require File.join(File.dirname(__FILE__), "../spec_helper")


class Temp
  
  def call bla
    "Temp was called"
  end
end


module Emailer
  describe TestingMiddleware do

    EMAIL = {
      :to => "test@test.se",
      :from => "test@test.se",
      :subject => "What subjcet ?",
      :body => "<html>"
    }
    
    before :each do
      Emailer::SmtpFacade.default = Emailer::MockSmtpFacade.new 
    end

    describe :call do
      
      it 'Should return an email when given the correct enviorment url' do
        
        Emailer::SmtpFacade.default.open do |smtp|
          smtp.send_html(
            EMAIL
          )
        end
        
        tm = TestingMiddleware.new(Temp.new)
        tm.call("PATH_INFO" => Emailer::SmtpFacade.default.last_email_sent_url)[2][0].should == EMAIL[:body]
        
      end
      
      it 'Should return "No email sent" if we havent sent any emails yet' do
        
        tm = TestingMiddleware.new(Temp.new)
        tm.call("PATH_INFO" => Emailer::TestingMiddleware.testing_path)[2][0].should == "No email sent"
        
      end
      
      it 'Should return "No email with that ID" if we supplie the wrong id' do
        
        Emailer::SmtpFacade.default.open do |smtp|
          smtp.send_html(
            EMAIL
          )
        end
        
        tm = TestingMiddleware.new(Temp.new)
        tm.call("PATH_INFO" => Emailer::SmtpFacade.default.get_url_for("ueoueo"))[2][0].should == "No email with that ID"
        
      end
      
      it 'Should pass on the call if the url dosent match' do
        tm = TestingMiddleware.new(Temp.new)
        tm.call("PATH_INFO" => "/").should == "Temp was called"
      end
      
     end
    
    

  end
end

