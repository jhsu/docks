module Docks
  class Generator

    # Generate yard documentation for a project.
    #
    # ship - instance of Ship.
    #
    # Returns successfulness.
    def self.yard(ship)
      # success = false
      result = nil
      Dir.chdir(ship.path) do
        output = IO.popen('yard')
        result = output.readlines
      end
      # success
      result
    end
  end
end
