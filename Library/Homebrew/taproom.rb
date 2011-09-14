# -*- coding: utf-8 -*-
require 'time'
# Results from the GitHub API are serialized to disk using YAML to keep API
# traffic low.
require 'yaml'

require 'vendor/httparty'

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
    @url = args[:url] || "https://github.com/#{owner}/#{name}.git"
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
    # GitHub paginates API v3 responses---so we set the number returned to 100
    # (the maximum)
    hub_request = self.class.get("/#{@owner}/#{@name}/forks", :query => {:per_page => 100})
    network = hub_request.parsed_response

    # We may need to issue additional requests in order to get all the data. If
    # there is more than one page available, the response will have a 'link'
    # header.
    unless hub_request.headers['link'].nil?
      # Try to find the link flagged as `rel=last`---that will let us know how
      # many pages we have. This part is a bit messy: a cleaner approach would
      # be much appreciated.
      links = hub_request.headers['link'].split ','
      last_page = links.select {|s| s.split(';')[1].match /last/}[0]
      last_page = last_page.match(/page=(\d+)/)[1] unless last_page.nil?

      unless last_page.nil?
        last_page = last_page.to_i
        (2..last_page).each do |i|
          hub_request = self.class.get("/#{@owner}/#{@name}/forks", :query => {:page => i, :per_page => 100})
          network += hub_request.parsed_response
        end
      end
    end

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

# Where we store clones of external repositories.
#
# Currently external repository support is hardcoded to work with repositories
# in the fork network of Adam's homebrew-alt. There are two reasons this was
# done:
#
#   * The fork network provides a convenient way to discover new
#     repositories.
#
#   * The repositories have a "known structure" in that every *.rb file
#     contained within is a homebrew formula.
#
# Hopefully, someday this infrastructure can be generalized to include any git
# repository that contains Homebrew formulae.
HOMEBREW_TAPROOM = Taproom.new HOMEBREW_PREFIX + 'Library' + 'Taproom', Brewery.new({:owner => 'adamv', :name => 'homebrew-alt'})
