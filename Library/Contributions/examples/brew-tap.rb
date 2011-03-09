# -*- coding: utf-8 -*-
require 'time'
require 'yaml'

require 'rubygems'
# HTTParty is used because it provides a nice abstraction for querying the
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


TAPROOM = HOMEBREW_PREFIX + 'Library' + 'Taproom'
FOUNDING_BREWERY = {:owner => 'adamv', :name => 'homebrew-alt'}


module Homebrew extend self
  def tap_dispatch taproom
    # Main entry point. Responsible for dispatching calls to brew-tap
    # subcommands. Modeled after the dispatch method of brew it's self.
    cmd = ARGV.shift
    if cmd == 'list'
      Homebrew.tap_list taproom
    elsif cmd == 'update'
      Homebrew.tap_update taproom
    end
  end

  def tap_list taproom
    # Lists repositories available for tapping
    menu = taproom.menu
    ohai "Available breweries:\n"
    menu[:breweries].each do |brewery|
      puts <<-EOS.undent
      #{brewery.brew_id}:
        Name: #{brewery.name}
        Brewmaster: #{brewery.owner}

      EOS
    end
    ohai "Menu last updated: #{menu[:menu_updated]}"
  end

  def tap_update taproom
    # Update list of available repositories and perform `brew update`-like
    # operations on them
    taproom.update_menu
  end
end

class Brewery
  # A Brewery represents a GitHub repository containing Homebrew formulae.
  include HTTParty
  base_uri 'github.com/api/v2/json/repos/show'
  format :json

  attr_reader :owner, :name, :brew_id

  def initialize args
    @owner = args[:owner]
    @name = args[:name]
    @brew_id = args[:brew_id] || [owner, name].join('-')
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
    ohai "Fetching #{@owner}'s #{@name} network"
    network = self.class.get("/#{@owner}/#{@name}/network").parsed_response['network']
    network.map do |repo|
      # We don't need all the information returned in the network array.
      # Abstract the important bits into new Brewery objects.
      brewery = Brewery.new :owner => repo['owner'], :name => repo['name']
    end
  end

  def get_branches
    ohai "Fetching #{@owner}'s #{@name} branch list."
    self.class.get("/#{@owner}/#{@name}/branches").parsed_response['branches']
  end

  def get_default_branch
    # TODO: Decide if this method is necessary or not.
    #
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


class Taproom
  # The Taproom manages the offerings of several breweries.
  attr_reader :path, :menu_path, :founder

  def initialize path, founder
    if not File.directory?(path)
      Dir.mkdir path # Or die? Needz moar error checking!
    end

    @path = path
    @menu_path = path + 'menu.yml'

    # The fork network of the "founding brewery" is used to generate the menu
    # available at this taproom. Not the most generalized, future-proof way to
    # do it, but we have to start somewhere.
    @founder = founder
  end

  def menu
    @menu ||= get_menu
  end

  def get_menu
    if not File.exists? @menu_path
      update_menu
    end

    menu = YAML.load_file @menu_path
    menu[:breweries] = menu[:breweries].map {|b| Brewery.new b}

    return menu
  end

  def update_menu
    menu = {:menu_updated => Time.now, :breweries => @founder.network.map {|b| b.to_hash}}
    File.open(@menu_path, 'w') {|file| file.write(menu.to_yaml)}
  end
end

Homebrew.tap_dispatch Taproom.new(TAPROOM, Brewery.new(FOUNDING_BREWERY))

