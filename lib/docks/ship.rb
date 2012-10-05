module Docks
  # Ship represents a git repository.
  class Ship

    # Get the path for projects, defaults to app root.
    #
    # Returns the path.
    def self.home
      @home ||= begin
        path = File.expand_path(File.join(File.dirname(__FILE__), "../../projects"))
        File.exists?(path) || Dir.mkdir(path)
        path
      end
    end

    # Set home path for projects.
    #
    # path - Full path of the projects directory.
    #
    # Returns the path.
    def self.home=(path)
      @home = path
    end

    # Ship has a name corresponding with the repository name and a url that
    # links to the github repository page.
    attr_accessor :name, :url

    # Receive payload updates.
    #
    # payload - A hash of information from post-receive from github.
    # 
    # Returns a boolean.
    def self.receive(payload)
      if payload['ref'] =~ /master$/
        repo = payload['repository']
        ship = new(repo)
        ship.checkout unless ship.exists?
        ship.update
        ship
      end
    end

    def initialize(attributes)
      @name, @url = attributes.values_at('name', 'url')
    end

    # Get the url for the github project.
    #
    # Returns a string of the url.
    def url
      @url ||= Dir.chdir(path) {
        %x[git config --get remote.origin.url].chomp.
          gsub(/^git/, 'https').gsub(/\.git$/, '')
      }
    end

    def revision
      Dir.chdir(path) do
        %x[cat .git/refs/heads/master].chomp
      end
    end

    # Check if repository is checked out.
    #
    # Returns boolean if directory exists.
    def exists?
      File.exists?(path)
    end

    # Clone the repository into the home directory.
    #
    # Returns an array of exit code, stdout and stderr.
    def checkout
      status, out, err = grit.clone({:process_info => true, :quiet => false, :progress => true}, git_url, path)
      [status, out, err]
    end

    # Local path for repository.
    #
    # Returns a string.
    def path
      @path ||= File.join(self.class.home, @name)
    end

    # Git url for the repository.
    #
    # Returns a string.
    def git_url
      @git_url ||= @url.gsub(/^https?:\/\/github\.com\//, "git@github.com:") + ".git"
    end

    # Update the local repository if needed
    #
    # Returns a boolean.
    def update
      # how do you do this with grit?
      Dir.chdir(path) do
        %x[git pull]
      end
    end

    def grit
      exists? ? Grit::Git.new(File.join(path, ".git")) : Grit::Git.new("/tmp/cloud")
    end

  end
end
