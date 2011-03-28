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

# Load the official Homebrew updater
require 'cmd/update'

# Status:
#
# Done:
#
#   - Repository listing
#   - Repository cloning
#   - Resolution of non-standard formulae names to brewfile paths inside
#     alternative repos
#   - Partial matching for repository names
#   - Repository removal
#   - Option for restricting formulae resolution to a specific
#     repository/subfolder
#   - Deal with multiple copies of the same formula
#   - Repository update
#   - Usage message
#
# TODO:
#
#   - Dependency resolution---this one will be tricky
#   - Proper classes for exceptions.


module Homebrew extend self
  def tap
    # Some hardcoded parameters---hopefully these can be generalized in the
    # future.
    taproom_path = HOMEBREW_PREFIX + 'Library' + 'Taproom'
    founding_brewery = {:owner => 'adamv', :name => 'homebrew-alt'}
    taproom = Taproom.new(taproom_path, Brewery.new(founding_brewery))

    tap_usage = <<-EOS
brew-tap: Manage external repositories containing Homebrew formulae
Usage: brew tap subcommand

Where subcommand is one of the following:

list
  List repositories that are cloned and available for brewing along with all
  additional repositories available in the homebrew-alt network.

add name
  Clone a repository so that the formula it contains are available for brewing.
  `name` is a repository name as given by `brew tap list`. Case-sensitive
  partial matching is available to save some typing.

remove name
  Remove a cloned repository.

update
  Update the contents of each cloned repository and rescan the homebrew-alt
  network to update `brew tap list`.

brew_command [options] formula_names
  Resolve each formula_name to a path within a cloned repository and recall
  the brew command with the resolved name:

      brew brew_subcommand [options] resolved_formula_names

  Options are passed through unchanged. Not all brew subcommands will work
  correctly, some common ones that do work are install, options and info.

  Formula names may be specified plain:

      brew tap install gcc

  Or, in the case of multiple repositories providing multiple copies of the
  same formula, a path-like name may be used:

      brew tap install adamv/dup/gcc

  Case-sensitive partial matching will be used to transform this into:

      adamv-homebrew-alt/duplicates/gcc
    EOS

    # Entry point for Homebrew. Responsible for parsing the command line and
    # executing brew-tap subcommands.
    if ARGV.empty?
      puts tap_usage
      exit 0
    end

    cmd = ARGV.shift
    if cmd == 'help'
      exec "man #{HOMEBREW_PREFIX + 'share' + 'man' + 'man1' + 'brew-tap.1'}"
    elsif cmd == 'list'
      # Lists tapped repositories and available repositories
      ohai "Repositories on tap:\n"
      taproom.tapped.each do |brewery|
        puts <<-EOS.undent
        #{brewery.id}
          Brewmaster: #{brewery.owner}

        EOS
      end

      ohai "Untapped repositories (clone with `brew tap add repo_name`):\n"
      taproom.untapped.each do |brewery|
        puts <<-EOS.undent
        #{brewery.id}
          Brewmaster: #{brewery.owner}

        EOS
      end

      ohai "Menu last updated: #{taproom.menu[:menu_updated]}"
    elsif cmd == 'update'
      # Update list of available repositories and perform `brew update`-like
      # operations on them
      taproom.restock
      taproom.update_menu
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

      # Resolve formula names to paths in subdirectories of the taproom_path.
      formulae.map! {|f| taproom.get_formula f}

      # Dispatch back to brew
      system "brew", cmd, *formulae.concat(options)
    end
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
    network = self.class.get("/#{@owner}/#{@name}/network").parsed_response['network']
    network.map do |repo|
      # We don't need all the information returned in the network array.
      # Abstract the important bits into new Brewery objects.
      brewery = Brewery.new :owner => repo['owner'], :name => repo['name']
    end
  end

  def get_branches
    self.class.get("/#{@owner}/#{@name}/branches").parsed_response['branches']
  end

  def get_default_branch
    # Unfortunately, GitHub has not implemented this natively in their API...
    # yet. They keep saying they will and the last response was something along
    # the lines of "Ooops, that was supposed to be in the last update". So
    # it will happen eventually. The workaround is to use git ls-remote to find
    # the remote HEAD and compare its SHA against the branch list.
    git_info = `git ls-remote #{@url}`.to_a
    hub_head = Hash[git_info.map{|line| line.split.reverse}].fetch 'HEAD'
    branches.invert.fetch hub_head # Unfortunately, this  can fail to specify a
                                   # unique branch name if two branches
                                   # share the same SHA (i.e. a branch other
                                   # than the default branch is in perfect sync
                                   # with it.) This should not be important for
                                   # pulling, but would be important if you
                                   # absolutely needed the correct branch name
                                   # for some reason.
  end
end


# We add and modify some methods of the official Homebrew updater that allow it
# to be used on breweries.
class RefreshBrew
  def update_from_brewery! taproom_path, brewery
    output = ''
    (taproom_path + brewery.id).cd do
      # See caveat in Brewery class concerning default_branch. Under some
      # unlikely circumstances, we may end up pulling from a branch that is
      # not actually the master---but it should bring in the same content as
      # the SHA will be the same. This caveat probably isn't important for a
      # pull.
      #
      # Probably.
      output = execute "git pull #{brewery.url} #{brewery.default_branch}"
    end

    output.split("\n").reverse.each do |line|
      case line
      when %r{^\s+create mode \d+ (.+?)\.rb}
        @added_formulae << $1
      when %r{^\s+delete mode \d+ (.+?)\.rb}
        @deleted_formulae << $1
      when %r{^\s+(.+?)\.rb\s}
        @updated_formulae << $1 unless @added_formulae.include?($1) or @deleted_formulae.include?($1)
      end
    end

    @added_formulae.sort!
    @deleted_formulae.sort!
    @updated_formulae.sort!

    # Return true/false depending on if git actually pulled new changes
    output.strip != GIT_UP_TO_DATE
  end

  def report
    ## New Formulae
    if pending_new_formulae?
      ohai "The following formulae are new:"
      puts_columns added_formulae
    end
    ## Deleted Formulae
    if deleted_formulae?
      ohai "The following formulae were removed:"
      puts_columns deleted_formulae, installed_formulae
    end
    ## Updated Formulae
    if pending_formulae_changes?
      ohai "The following formulae were updated:"
      puts_columns updated_formulae, installed_formulae
    else
      puts "No formulae were updated."
    end
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

  def restock
    abort "Please `brew install git' first." unless system "/usr/bin/which -s git"

    # Iterate over each tapped brewery and run the equivalent of `brew update`
    tapped.each do |brewery|
      updater = RefreshBrew.new

      if updater.update_from_brewery! @path, brewery
        puts "Updated #{brewery.id}."
        updater.report
      else
        puts "#{brewery.id} already up-to-date."
      end
      print "\n"
    end
  end

  def on_tap? name
    # Has a given brewery been tapped (cloned)?
    File.directory? @path + name
  end

  def tapped
    # Return tapped breweries.
    menu[:breweries].select {|b| on_tap? b.id}
  end

  def untapped
    # Return untapped breweries.
    menu[:breweries].select {|b| not on_tap? b.id}
  end

  def get_brewery name
    # Searches the Taproom menu for a brewery whose id matches `name`.  Partial
    # matching is used, but since ids are unique we require that `name` be long
    # enough to generate a single match.
    brewery = menu[:breweries].select {|b| b.id =~ /^#{name}/}
    if brewery.empty?
      raise "No repository named #{name} on the menu!"
    elsif brewery.length > 1
      onoe "More than one brewery starts with #{name}:"
      puts_columns brewery
      raise "Please specify enough of the brewery name for a unique match."
    else
      brewery[0]
    end
  end

  def get_formula name
    # Searches through the available formulae for a formula that matches the
    # given name. Formula names can be plain:
    #
    #     gcc
    #
    # Or a path-like object of the form repo/[optional subdirectories]/formula:
    #
    #     adamv/duplicates/gcc
    #
    # A file glob, '*' will be appended to the end of each path component
    # (other than the formula) to allow for partial matching.
    d_names, f_name = Pathname.new(name).split

    search_dirs = []
    d_names.each_filename do |fname|
      unless fname == '.'
        search_dirs << fname + '*'
      end
    end

    matches = Dir[File.join(@path, search_dirs, '**', "#{f_name}.rb")]

    if matches.empty?
      raise "No formula for #{f_name} available in the Taproom."
    elsif matches.length > 1
      onoe "Multiple matches found when searching for #{name}:"

      # Clean up the paths so they look like potential arguments that could be
      # passed to ensure a unique match.
      matches.map! do |p|
        p.sub! /^#{@path}\//, ''
        p.sub! /\.rb$/, ''
      end

      puts_columns matches

      raise "Try using repo/[subdirectories]/formula to narrow the search range."
    else
      matches.first
    end
  end

  def tap name
    # This method will run a checkout on the specified brewery.
    brewery = get_brewery name

    if on_tap? brewery.id
      ohai "#{brewery.id} is allready on tap. Brew away!"
      return
    end

    checkout_path = @path + brewery.id

    if not File.directory? checkout_path
      safe_system "git clone #{brewery.url} #{checkout_path}"
    end
  end

  def remove name
    # This method will remove the specified brewery from the Taproom directory.
    brewery = get_brewery name

    if not on_tap? brewery.id
      onoe "#{brewery.id} has not been tapped. No need to remove it."
      return
    end

    checkout_path = @path + brewery.id

    ohai "Unlinking #{checkout_path}..."
    FileUtils.rm_rf checkout_path
  end
end


# Here is the actual code that gets run when `brew` loads this external
# command.
Homebrew.tap

