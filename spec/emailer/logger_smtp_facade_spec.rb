require File.join(File.dirname(__FILE__), "../spec_helper")

module Emailer
  describe LoggerSmtpFacade do
       
    LOGGER_OPTIONS = {
        :log_file => '/tmp/emailLog.txt',
        :use => MockSmtpFacade.new
    }
    
    TEST_LOG_FILE = '/tmp/test_emailLog.txt'
    
    describe :initialize do
      it "should accept only known options" do
        lambda do
          LoggerSmtpFacade.new(:log_file => '/tmp/emailLog.txt', :foobar => 'fail')
        end.should raise_error
      end
      
      it "should accept all known options" do
        LoggerSmtpFacade.new LOGGER_OPTIONS
      end
      
      it "should demand temp_dir option" do
        lambda do
          LoggerSmtpFacade.new
        end.should raise_error
      end
    end

    describe :send_mail do

      before(:each) do
        File.unlink(TEST_LOG_FILE) if File.exist?(TEST_LOG_FILE)
      end

      it "should write the email to the log file" do

        smtp = LoggerSmtpFacade.new :log_file => TEST_LOG_FILE

        smtp.open do
          smtp.send_mail(
          :to => "test@bits2life.com",
          :from => "test2@bits2life.com",
          :subject => "This is a test 3",
          :body => "Blabla"
          )
        end

        ((File.read(TEST_LOG_FILE,File::RDONLY|File::CREAT).to_s+"").include? "This is a test 3").should == true
      end

      it "should log and pass the email on to the supplied SmtpFacade" do
        
        mock = MockSmtpFacade.new
        smtp = LoggerSmtpFacade.new :log_file => TEST_LOG_FILE, :use => mock

        email = { 
          :to => "test@bits2life.com",
          :from => "test2@bits2life.com",
          :subject => "This is a test 4",
          :body => "Test body"
        }

        smtp.open do
          smtp.send_mail email
        end
        
        mock.last_email_sent.should == email
          
      end
    end
      
    

   # Should be able to wrap another smtp facade
   # Should have temp directory configurable
   # Should be abel to log to one file
   # Should be able to log to many files
   # Should write to many files as html files viewable in a browser
   # Should write to one file as ruby code style
   # Should bork if no directory is supplied
    
  end
end