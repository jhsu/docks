$:.unshift File.join(File.dirname(__FILE__), "lib")
require 'docks'

CONFIG = YAML.load_file(File.expand_path(File.join(File.dirname(__FILE__), "config/docks.yml")))

projects = CONFIG['projects']
projects.each do |name|
  url = "https://github.com/#{CONFIG['org_id']}/#{name}"
  ship = Docks::Ship.new('name' => name, 'url' => url)
  ship.checkout unless ship.exists?
  Docks::Generator.yard(ship)
end

use Rack::Static, :urls => projects.map {|name| "/#{name}" }, :root => "projects"
run Docks::App