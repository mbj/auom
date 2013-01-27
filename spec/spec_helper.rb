require 'rspec'

$LOAD_PATH << File.expand_path('../lib', __FILE__)

Dir.glob('spec/examples/**/*.rb').each { |file| require File.expand_path(file) }
Dir[File.expand_path('../{support,shared}/**/*.rb', __FILE__)].each { |f| require f }

if RUBY_VERSION < '1.9'
  require 'rspec/autorun'
end

require 'auom'
