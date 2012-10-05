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
      @projects = CONFIG['projects']
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
@@ index
<ul>
  <% @projects.each do |name| %>
  <li><a href="<%= name %>/doc/frames.html"><%= name %></a></li>
  <% end %>
</ul>
