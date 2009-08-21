$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'emailer'
require 'emailer/mock_smtp_facade'
require 'spec'
require 'spec/autorun'

Spec::Runner.configure do |config|
  
end
