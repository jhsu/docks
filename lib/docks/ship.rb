module Docks
  class NoHome < Exception; end

  # Ship represents a git repository.
  class Ship
    class << self
      attr_accessor :home
    end

    # Ship has a name corresponding with the repository name and a url that
    # links to the github repository page.
    attr_accessor :name, :url

    REF = "refs/heads/master"

    # Receive payload updates.
    #
    # payload - A hash of information from post-receive from github.
    # 
    # Returns a boolean.
    def self.receive(payload)
      if payload['ref'] == REF
        repo = payload['repository']
        ship = new(repo)
        ship.checkout unless ship.exists?
        ship.update
        ship
      end
    end

    def initialize(attributes)
      @name, @url = attributes.values_at('name', 'url')
      unless exists?
        checkout
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
    # Returns status code.
    def checkout
      raise Docks::NoHome unless self.class.home

      grit = Grit::Git.new("/tmp/cloud")
      status, out, err = grit.clone({:process_info => true, :quiet => false, :progress => true}, git_url, path)
      status
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
      @git_url ||= @url.gsub(/^https?:\/\/github\.com/, "git://github.com")
    end

    # Update the local repository if needed
    #
    # Returns a boolean.
    def update
    end

  end
end
