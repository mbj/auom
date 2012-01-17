$: << File.expand_path(File.join(File.dirname(__FILE__),'..','lib'))
require 'sunits'
Dir.glob(File.join('./spec/**/*_shared.rb')).each { |f| require f }
