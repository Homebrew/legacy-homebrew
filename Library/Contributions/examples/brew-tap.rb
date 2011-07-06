# -*- coding: utf-8 -*-
require 'time'
# Results from the GitHub API are serialized to disk using YAML to keep API
# traffic low.
require 'yaml'

require 'rubygems'
# HTTParty is used for querying the GitHub API and de-serializing the JSON
# responses to ruby objects. However, only a couple of API calls are ever
# made---so HTTParty could probably be ditched in favor of a system call to
# curl with no great loss in exchange for removing the dependency.
#
# On the other hand, a JSON de-serializer would still be required as GitHub is
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

# `brew-tap update` recycles some of the machinery from `brew update`
require 'cmd/update'
require 'formula'


module Homebrew extend self
  def tap
    # Some hardcoded parameters---currently brew-tap is designed to work with
    # repositories in the fork network of Adam's homebrew-alt. There are two
    # reasons this was done:
    #
    #   * The fork network provides a convenient way to discover new
    #     repositories.
    #
    #   * The repositories have a "known structure" in that every *.rb file
    #     contained within is a homebrew formula.
    #
    # Hopefully, this infrastructure can be generalized to include any git
    # repository that contains Homebrew formulae.
    taproom_path = HOMEBREW_PREFIX + 'Library' + 'Taproom'
    founding_brewery = {:owner => 'adamv', :name => 'homebrew-alt'}
    taproom = Taproom.new(taproom_path, Brewery.new(founding_brewery))

    tap_usage = <<-EOS
Usage: brew tap <command> [args]
Commands:

list
  List available alternate repositories.

update
  Pull updates into cloned repositories. Also refreshes the list of available
  alternate repositories.

add <repository>
remove <repository>
  Clone alternate repositories with add. Delete them with remove.

which <formulae>...
  Resolve formula names to alternate brewfiles and then print paths to those
  brewfiles.

<brew command> [--options] [<formulae>...]
  Run a brew command, such as install, using formulae in cloned alternate
  repositories.

See 'brew tap help' for more detailed information.
    EOS

    if ARGV.empty?
      puts tap_usage
      exit 0
    end

    case cmd = ARGV.shift
    when 'help'
      exec "man #{HOMEBREW_PREFIX}/share/man/man1/brew-tap.1"

    when 'list'
      # Lists tapped repositories and available repositories separately. The
      # list of available repositories is generated from the fork network of
      # the "founding brewery" using the GitHub API. This list is only updated
      # when `brew tap update` is called.
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

    when 'update'
      # Update list of available repositories and perform `brew update`-like
      # operations on them
      taproom.restock!
      taproom.update_menu!

    when 'add'
      raise "A repository name must be passed to brew-tap add!" if ARGV.empty?
      brewery_name = ARGV.shift
      taproom.tap! brewery_name

    when 'remove'
      raise "A repository name must be passed to brew-tap remove!" if ARGV.empty?
      brewery_name = ARGV.shift
      taproom.remove! brewery_name

    when 'which'
      formulae = ARGV.named
      raise FormulaUnspecifiedError if formulae.empty?
      formulae.map! {|f| taproom.get_brewfile f}
      puts formulae

    when 'install'
      # We handle `brew install` separately from other brew commands in order
      # to perform dependency resolution.
      formulae = ARGV.named
      options = ARGV.options_only

      raise FormulaUnspecifiedError if formulae.empty?

      if ARGV.include? '--ignore-dependencies'
        formulae.map! {|f| taproom.get_brewfile f}
      else
        formulae.map! {|f| gather_dependencies f, taproom}
        formulae.flatten!
        formulae.compact!
        formulae.uniq!
      end

      # Dispatch back to brew
      system "brew", cmd, *formulae.concat(options)

    else
      # At this point, we expect cmd is a `brew` subcommand followed by one or
      # more non-standard formulae. The task is to resolve these formulae to
      # pathnames in the Taproom repositories and recall brew.
      formulae = ARGV.named
      options = ARGV.options_only

      # Resolve formula names to paths in subdirectories of the taproom_path.
      formulae.map! {|f| taproom.get_brewfile f}

      # Dispatch back to brew
      system "brew", cmd, *formulae.concat(options)
    end
  end

  def gather_dependencies formula, taproom
    # If the given formula has dependencies declared using the `:alt` keyword,
    # attempt to discover them using the repositories contained in the given
    # taproom. If any dependencies are not installed, add them to the list of
    # formulae to install.
    begin
      formula = taproom.get_brewfile formula
    rescue FormulaUnavailableError => e
      begin
        # A formula may not be available, because the repository it belongs to
        # may not be checked out. Try tapping the repository and searching for
        # the brewfile again.
        brewery = (formula.split '/').first
        ohai "Tapping #{brewery} to satisfy dependency #{formula}"
        taproom.tap! brewery
        formula = taproom.get_brewfile formula
      rescue
        # Our heroic efforts failed, time to give up and throw the original
        # error.
        raise e
      end
    end

    # Check for dependencies
    formula = Formula.factory formula
    deps = formula.external_deps[:alt]

    if formula.installed?
      # Formula that are already installed are assigned a path of nil so they
      # may be eliminated by a later call to `compact`. This prevents brew from
      # throwing "already installed" errors when it is recalled.
      formula_path = nil
    else
      formula_path = formula.path
    end

    # If the formula doesn't have any alternate dependencies, we just return
    # it.
    if deps.nil? or deps.empty?
      return formula_path
    else
      return deps.map {|dep| gather_dependencies dep, taproom} << formula_path
    end
  end
end


class Brewery
  # A Brewery represents a GitHub repository containing Homebrew formulae.

  # HTTParty configuration
  include HTTParty
  base_uri 'https://api.github.com/repos'
  format :json

  attr_reader :owner, :name, :id, :url

  def initialize args
    @owner = args[:owner]
    @name = args[:name]
    # id should be a unique identifier that could be to clone this repository,
    # along with several others from the same network, and not worry about
    # folder names clashing with each other.
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

  def master
    @master ||= get_master_branch
  end


  private
  # These methods all hit the GitHub API. Therefore, they should only be
  # invoked through the memoized accessors defined above.
  def get_network
    network = self.class.get("/#{@owner}/#{@name}/forks").parsed_response

    # Convert the JSON results to Brewery objects
    network.map! do |repo|
      # We don't need all the information returned in the network array.
      # Abstract the important bits into new Brewery objects.
      brewery = Brewery.new :owner => repo['owner']['login'], :name => repo['name']
    end

    # Version 3 of the GitHub api only offers a "fork network" which doesn't
    # include the original repository. So we push a copy of this repo onto the
    # list of results.
    network.push self
  end

  def get_branches
    self.class.get("/#{@owner}/#{@name}/branches").parsed_response
  end

  def get_master_branch
    # When no value is returned by the API, the master branch is named master.
    self.class.get("/#{@owner}/#{@name}").parsed_response['master_branch'] || 'master'
  end
end


# We add and modify some methods of the official Homebrew updater that allow it
# to be used on breweries. Basically, we change the target of the git commands
# and reduce the reporting to formula files only.
class RefreshBrew
  def update_from_brewery! taproom_path, brewery
    brewery_path = taproom_path + brewery.id

    brewery_path.cd do
      safe_system "git checkout -q #{brewery.master}"
      @initial_revision = read_revision
      execute "git pull #{brewery.url} #{brewery.master}"
      @current_revision = read_revision
    end

    if initial_revision && initial_revision != current_revision
      # hash with status characters for keys:
      # Added (A), Copied (C), Deleted (D), Modified (M), Renamed (R)
      @changes_map = Hash.new {|h,k| h[k] = [] }

      changes = brewery_path.cd do
        execute(DIFF_COMMAND % [initial_revision, current_revision]).split("\0")
      end

      while status = changes.shift
        file = changes.shift
        @changes_map[status] << file
      end

      if @changes_map.any?
        # We assume all paths inside a brewery that end in .rb are formula
        # files
        @added_formulae   = changed_items('A', '')
        @deleted_formulae = changed_items('D', '')
        @updated_formulae = changed_items('M', '')

        @installed_formulae = HOMEBREW_CELLAR.children.
          select{ |pn| pn.directory? }.
          map{ |pn| pn.basename.to_s }.sort if HOMEBREW_CELLAR.directory?

        return true
      end
    end
    # assume nothing was updated
    return false
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
  # The Taproom manages a folder into which "breweries" (repositiories) are
  # placed "on tap" (cloned). The Taproom class mantains a list of cloned
  # repositories and available repositories called the "menu". It manages the
  # cloning and removal of repositories and resolves formulae names to
  # brewfiles within the cloned repositories.
  attr_reader :path, :menu_path, :founder

  def initialize path, founder
    @path = Pathname.new path

    if not File.directory? path
      Dir.mkdir path rescue raise "Unable to create Taproom directory at #{path}!"
    end

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
      update_menu!
    end

    menu = YAML.load_file @menu_path
    menu[:breweries] = menu[:breweries].map {|b| Brewery.new b}

    return menu
  end

  def update_menu!
    menu = {:menu_updated => Time.now, :breweries => @founder.network.map {|b| b.to_hash}}
    File.open(@menu_path, 'w') {|file| file.write(menu.to_yaml)}
  end

  def restock!
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
      puts_columns brewery.map {|b| b.id}
      raise "Please specify enough of the brewery name for a unique match."
    else
      brewery[0]
    end
  end

  def get_brewfile name
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
    d_names.each_filename {|d| search_dirs << d + '*' unless d == '.'}

    matches = Dir[File.join(@path, search_dirs, '**', "#{f_name}.rb")]

    if matches.empty?
      raise FormulaUnavailableError.new f_name
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

  def tap! name
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

  def remove! name
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

