
require 'minitest/autorun'
require "minitest/reporters"
Minitest::Reporters.use!

require 'debug'

Dir[File.expand_path("../lib/*.rb", __dir__)].each {|file| require file } # load ruby files