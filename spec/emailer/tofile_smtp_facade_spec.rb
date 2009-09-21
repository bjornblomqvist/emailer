require File.join(File.dirname(__FILE__), "../spec_helper")

module Emailer
  describe ToFileSmtpFacade do
    
    FILE_DIR = '/tmp/emails/'
    
    TOFILE_OPTIONS = {
      :file_dir => FILE_DIR,
      :use => nil
    }
    
    describe :init do 
      it 'Should accept all valid options' do
        ToFileSmtpFacade.new TOFILE_OPTIONS
      end
      
      it 'Should only accept valid options' do
        lambda do 
          ToFileSmtpFacade.new :file_dir => FILE_DIR, :foo => 'foo'
        end.should raise_error
      end
      
      it 'Should demand that :file_dir option is supplied' do
        lambda do 
          ToFileSmtpFacade.new
        end.should raise_error
      end
    end
    
    describe :send_mail do
      it 'Should create a new file with the name of from and to addresses' do
        smtp = ToFileSmtpFacade.new :file_dir => FILE_DIR     
        smtp.open do
          smtp.send_mail(
            :to => 'test@bits2life.com',
            :from => 'test2@bits2life.com',
            :subject => 'a test subject',
            :body => 'A test message'
          )
        end
        
        found = false
        Dir.entries(FILE_DIR).each do |entry|
          found = true if entry.include? 'test@bits2life.com'
        end
        
        found.should == true
      end
      
      it 'Should send an email using the supplied facade' do
        mockSmtp = MockSmtpFacade.new
        smtp = ToFileSmtpFacade.new :file_dir => FILE_DIR, :use => mockSmtp
        smtp.open do 
          smtp.send_mail(
            :to => "emma@bits2life.com",
            :from => "bjorn@bits2life.com",
            :subject => 'A test email to emma',
            :body => '<html><head></head><body><h1>This is a test</h1></body></html>'
          )
        end
        
        mockSmtp.sent.count.should == 1
      end
      
    end
  end
end