require File.join(File.dirname(__FILE__), "../spec_helper")

module Emailer
  describe MailQueue do
    
    before(:each) do
      @smtp = MockSmtpFacade.new
      @queue = MailQueue.new @smtp
    end
    
    describe "a new MailQueue" do
      it "should be empty" do
        @queue.should be_empty
      end
    end
    
    describe :add do
      before(:each) do
        @queue.add(
          :from => 'from@email.com',
          :to => 'to@email.com',
          :subject => 'subject',
          :body => 'body'
        )
      end
      
      it "should default :content_type to 'text/plain'" do
        @queue.last[:content_type].should == 'text/plain'
      end
      
      it "should default :encoding to 'utf-8'" do
        @queue.last[:encoding].should == 'utf-8'
      end
    end
    
    describe :add_html do
      it "should default :content_type to 'text/html'" do
        @queue.add_html(
          :from => 'from@email.com',
          :to => 'to@email.com',
          :subject => 'subject',
          :body => 'body'
        )
        @queue.last[:content_type].should == 'text/html'
      end
    end
    
    context "a mail queue with two mails" do
      def add_mail
        @queue.add(
          :from => 'from@email.com',
          :to => 'to@email.com',
          :subject => 'subject',
          :body => 'body'
        ) do |success, mail|
          @verified << mail
        end
      end
      
      before(:each) do
        @verified = []
        2.times { add_mail }
      end
      
      it "should not be empty" do
        @queue.should_not be_empty
      end
      
      context "when we call :process" do
        before(:each) do
          @queue.process
        end
        
        it "should send both mails" do
          @smtp.sent.length.should == 2
        end
        
        it "should call the mail's respective callbacks" do
          @verified.length.should == 2
        end
        
        it "should be empty" do
          @queue.should be_empty
        end
      end
      
      context "with an additional mail added" do
        before(:each) do
          add_mail
        end
        
        it "should have three mails" do
          @queue.length.should == 3
        end
        
        it "should send three mails when processed" do
          @queue.process
          @verified.length.should == 3
        end
      end
    end
    
  end
end
