require 'bundler'
Bundler.require(:default)
require 'yaml'

module Docks
  autoload :Ship, 'docks/ship'
  autoload :Generator, 'docks/generator'

  class App < Sinatra::Base
    enable :sessions
    enable :inline_templates

    set :github_options, {
      :scopes    => "user",
      :secret    => ENV['GITHUB_CLIENT_SECRET'],
      :client_id => ENV['GITHUB_CLIENT_ID'],
    }

    register Sinatra::Auth::Github

    CONFIG = YAML.load_file(File.expand_path(File.join(File.dirname(__FILE__), "../config/docks.yml")))

    helpers do
      def repos
        github_request("orgs/#{org_id}/repos")
      end

      def org_id
        @org_id ||= CONFIG['org_id']
      end

      def org_authenticate!
        github_organization_authenticate!(org_id)
      end
    end

    get '/' do
      org_authenticate!
      projects = CONFIG['projects']
      @projects = projects.map {|name| Ship.new('name' => name) }
      erb :index
    end

    post '/' do
      ship = Ship.receive(params[:payload])
      Generator.yard(ship)
    end

    get %r{/([\w]+)/(doc/.*)} do
      org_authenticate!
      project, file = params[:captures]
      send_file(File.join(Ship.home, project, file))
    end

  end
end

__END__
@@ layout
<html>
  <style type="text/css">
    .revision { color: #bbb; }
  </style>
  <body>
  <%= yield %>
  </body>
</html>

@@ index
<h2>Projects</h2>
<ul>
  <% @projects.each do |project| %>
  <li><a href="<%= project.name %>/doc/frames.html" title="<%= project.name %> Documentation">
  <%= project.name %></a>
    <span class="revision"><%= project.revision %></span></li>
  <% end %>
</ul>
