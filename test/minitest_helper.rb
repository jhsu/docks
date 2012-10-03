require 'minitest/spec'
require 'minitest/autorun'

require 'docks'
require 'json'

require 'fileutils'


path = File.expand_path(File.join(File.dirname(__FILE__), "projects"))
Docks::Ship.home = path
