$:.unshift File.join(File.dirname(__FILE__), "lib")
require 'docks'

CONFIG = YAML.load_file(File.expand_path(File.join(File.dirname(__FILE__), "config/docks.yml")))

projects = CONFIG['projects']
projects.each do |name|
  url = "https://github.com/#{CONFIG['org_id']}/#{name}"
  ship = Docks::Ship.new('name' => name, 'url' => url)
  ship.checkout unless ship.exists?
  ship.update
  Docks::Generator.yard(ship)
end

run Docks::App
