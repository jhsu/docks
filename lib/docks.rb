require 'bundler'
Bundler.require(:default)

module Docks
  autoload :Ship, 'docks/ship'
  autoload :Generator, 'docks/generator'

  class App < Sinatra::Base
    post '/' do
      ship = Ship.receive(params[:payload])
      Generator.yard(ship)
    end
  end
end
