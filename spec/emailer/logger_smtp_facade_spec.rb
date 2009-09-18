module Emailer
  
  LOGGER_OPTIONS = {
      :temp_dir => 'smtp.host.com',
      :use => MockSmtpFacade.new
  }
  
  describe LoggerSmtpFacade do
    
    describe :initialize do
      it "should accept only known options" do
        lambda do
          LoggerSmtpFacade.new :foobar => 'fail'
        end.should raise_error
      end
      
      it "should accept all known options" do
        LoggerSmtpFacade.new LOGGER_OPTIONS
      end
      
      it "should demand temp_dir option" do
        lambda do
          LoggerSmtpFacade.new
        end.shouldh raise_error
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