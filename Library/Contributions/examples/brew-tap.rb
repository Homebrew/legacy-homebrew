# -*- coding: utf-8 -*-
require 'time'
require 'yaml'

require 'rubygems'
# HTTParty is used because it provides a nice abstraction for querying the
# GitHub API and serializing the JSON responses to ruby objects. However, only
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
Some objects used by brew-tap need to communicate with the GitHub API.  This is
done using the HTTParty gem, but that gem could not be imported.
  EOS
  puts 'To install: gem install httparty'
  exit 1
end

# Status:
#
# Done:
#
#   - Repository listing
#   - Repository cloning
#   - Resolution of non-standard formulae names to brewfile paths inside
#     alternative repos
#
# TODO:
#
#   - Repository removal
#   - Repository update
#   - Partial matching for repository/subfolder names
#   - Option for restricting formulae resolution to a specific
#     repository/subfolder
#   - Deal with multiple copies of the same formula
#   - Dependency resolution---this one will be tricky
#   - Usage message
#   - Better Exception handling


TAPROOM = HOMEBREW_PREFIX + 'Library' + 'Taproom'
FOUNDING_BREWERY = {:owner => 'adamv', :name => 'homebrew-alt'}


module Homebrew extend self
  def tap_dispatch taproom
    # Main entry point. Responsible for dispatching calls to brew-tap
    # subcommands. Modeled after the dispatch method in the main brew script.
    cmd = ARGV.shift
    if cmd == 'list'
      Homebrew.tap_list taproom
    elsif cmd == 'update'
      Homebrew.tap_update taproom
    elsif cmd == 'add'
      raise "A repository name must be passed to brew-tap add!" if ARGV.empty?
      brewery_name = ARGV.shift
      taproom.tap brewery_name
    elsif cmd == 'remove'
      raise "A repository name must be passed to brew-tap add!" if ARGV.empty?
      brewery_name = ARGV.shift
      taproom.remove brewery_name
    else
      # At this point, we expect cmd is a `brew` subcommand followed by one or
      # more non-standard formulae. The task is to resolve these formulae to
      # pathnames in the Taproom repositories and recall brew.
      formulae = ARGV.named
      options = ARGV.options_only

      # Resolve formula names to paths in subdirectories of the TAPROOM.
      formulae.map! {|f| taproom.get_formula f}

      # Dispatch back to brew
      system "brew", cmd, *formulae.concat(options)
    end
  end

  def tap_list taproom
    # Lists repositories available for tapping
    # TODO: Print tapped and untapped repositories separately.
    menu = taproom.menu
    ohai "Available breweries:\n"
    menu[:breweries].each do |brewery|
      puts <<-EOS.undent
      #{brewery.id}
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

  attr_reader :owner, :name, :id, :url

  def initialize args
    @owner = args[:owner]
    @name = args[:name]
    # id should be a unique identifier that could be to clone this repository,
    # along with several others from the same network, and not worry about
    # folders overwriting each other.
    @id = args[:id] || [owner, name].join('-')
    @url = args[:url] || "git://github.com/#{owner}/#{name}.git"
  end

  def to_hash
    {:owner => @owner, :name => @name, :id => @id}
  end

  def to_s
    to_hash.inspect
  end

  def network
    # Memoize using '||=' so we don't slam the GitHub API with unnecessary
    # requests.
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
    ohai "Scanning #{@owner}'s #{@name} network"
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
    git_info = `git ls-remote #{@url}`.to_a
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

  def formulae
    # One of the nice things about only considering forks of homebrew-alt is
    # that any Ruby file in any subdirectory can be considered a homebrew
    # formula.
    Dir["#{@path}/**/*.rb"]
  end

  def get_formula name
    # Searches through the available formulae for a formula that matches the
    # given name.
    matches = formulae.select {|f| f.end_with? "#{name}.rb"}

    if matches.empty?
      raise "No formula for #{name} available in the Taproom"
    else
      matches.first
    end
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

  def list_available
    # Return list of all breweries, tapped or untapped.
    menu[:breweries].map {|b| b.id}
  end

  def on_menu? name
    # Does the menu contain a brewery?
    list_available.include? name
  end

  def on_tap? name
    # Has a given brewery been tapped?
    File.directory? @path + name
  end

  def list_tapped
    # Return list of tapped breweries.
    tapped = menu[:breweries].select {|b| on_tap? b.id}
    tapped.map {|b| b.id}
  end

  def get_brewery name
    brewery = menu[:breweries].select {|b| b.id == name}
    if brewery.empty?
      raise "No repository named #{name} on the menu!"
    else
      brewery[0] # Because id should be a unique identifier
    end
  end

  def tap brewery_name
    # This method will run a checkout on the specified brewery.
    if on_tap? brewery_name
      ohai "#{brewery_name} is allready on tap. Brew away!"
      return
    end

    brewery_path = @path + brewery_name
    brewery = get_brewery brewery_name

    if not File.directory? brewery_path
      safe_system("git clone #{brewery.url} #{brewery_path}")
    end
  end

  def remove brewery
    # This method will remove the specified brewery from the list of breweries
    # on tap.
    raise 'Not implemented.'
  end
end

# The actual code that gets run when `brew` loads this external command
Homebrew.tap_dispatch Taproom.new(TAPROOM, Brewery.new(FOUNDING_BREWERY))

