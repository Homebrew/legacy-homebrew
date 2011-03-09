# -*- coding: utf-8 -*-
require 'rubygems'

# HTTParty is used because it provides a nice set of functions for querying the
# GitHub API and marshaling the JSON response into ruby objects. However, only
# a couple of API calls are ever made---so HTTParty could probably be ditched
# in favor of a system call to curl with no great loss in exchange for removing
# the dependency.
#
# On the other hand, a JSON deserializer would still be required as GitHub is
# depreciating the XML and YAML (bummer!) options.
begin
  require 'httparty'
rescue LoadError
  onoe <<-EOS
Some objects used by brew-tap need to communicate with the GitHub API. They do
this using the HTTParty gem, but that gem could not be imported.
  EOS
  puts 'To install: gem install httparty'
  exit 1
end

class Brewery
  # A Brewery is a class that represents a GitHub repository that contains
  # Homebrew formulae.
  include HTTParty
  base_uri 'github.com/api/v2/json/repos/show'
  format :json

  attr_reader :owner, :name, :brew_id

  def initialize owner, name, brew_id = nil
    @owner = owner
    @name = name
    @brew_id = brew_id || [owner, name].join('-')
  end

  def to_hash
    {:owner => @owner, :name => @name, :brew_id => @brew_id}
  end

  def to_s
    to_hash.inspect
  end

  def network
    # Memoize so we don't slam the GitHub API with unnecessary requests.
    @network ||= get_network
  end

  def branches
    @branches ||= get_branches
  end

  def default_branch
    @default_branch ||= get_default_branch
  end


  private
  # These methods all hit the GitHub API. Therefore, they should only be
  # invoked through the memoized accessors defined above.
  def get_network
    puts "Fetching #{@owner}'s #{@name} network."
    network = self.class.get("/#{@owner}/#{@name}/network").parsed_response['network']
    network.map do |repo|
      # We don't need all the information returned in the network array.
      # Abstract the important bits into new Brewery objects.
      Brewery.new repo['owner'], repo['name']
    end
  end

  def get_branches
    puts "Fetching #{@owner}'s #{@name} branch list."
    self.class.get("/#{@owner}/#{@name}/branches").parsed_response['branches']
  end

  def get_default_branch
    # Unfortunately, GitHub has not implemented this natively in their API...
    # yet. They keep saying they will and the last response was something along
    # the lines of "Ooops, that was supposed to be in the last update". So
    # it will happen eventually. The workaround is to use git its self to find
    # the remote HEAD and compare its SHA against the branch list.
    git_info = `git ls-remote https://github.com/#{@owner}/#{@name}`.to_a
    hub_head = Hash[git_info.map{|line| line.split.reverse}].fetch 'HEAD'
    branches.invert.fetch hub_head # Unfortunately, this fails if two branches
                                   # share the same SHA (i.e. a branch other
                                   # than the default branch is in perfect sync
                                   # with it.)
  end
end

