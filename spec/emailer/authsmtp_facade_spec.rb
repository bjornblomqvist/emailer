require File.join(File.dirname(__FILE__), "../spec_helper")

module Emailer
  describe AuthSmtpFacade do
    
    describe :initialize do
      it "should default to standard AuthSMTP settings" do
        smtp = AuthSmtpFacade.new :username => 'username', :password => 'password', :domain => 'www.domain.com'
        smtp.settings[:host].should == 'mail.authsmtp.com'
        smtp.settings[:port].should == 2525
        smtp.settings[:authentication].should == :cram_md5
      end
    end
    
  end
end
