
module Emailer
  class MailQueue
    def initialize(smtp)
      @smtp = smtp
      @queue = []
    end
    
    def empty?
      @queue.empty?
    end
    
    def length
      @queue.length
    end
    
    def add(mail, &callback)
      mail[:content_type] ||= 'text/plain'
      mail[:encoding] ||= 'utf-8'
      
      @queue << mail.merge(:callback => callback)
    end
    
    def add_html(mail, &callback)
      add({ :content_type => 'text/html' }.merge(mail), &callback)
    end
    
    def last
      @queue.last
    end
    
    def process(tcount = 4)
      tcount = length if length < tcount
      
      threads = []
      mutex = Mutex.new
      
      tcount.times do |n|
        threads << Thread.new(n) do |tid|
          while !empty?
            send_mail mutex
          end
        end
      end
      
      threads.each { |thr| thr.join }
    end
    
    def send_mail(mutex)
      smtp = @smtp.clone
      smtp.open do
        while mail = mutex.synchronize { @queue.shift }
          result = smtp.send_mail mail
          mail[:callback].call(result, mail) if mail[:callback]
        end
      end
    end
    
  end
end