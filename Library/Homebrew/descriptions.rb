require "formula"
require "csv"

class Descriptions

  CACHE_FILE = HOMEBREW_CACHE + "desc_cache"

  def self.cache
    @cache || self.load_cache
  end

  # If the cache file exists, load it into, and return, a hash; otherwise,
  # return nil.

  def self.load_cache
    if CACHE_FILE.exist?
      @cache = {}
      CSV.foreach(CACHE_FILE) { |name, desc| @cache[name] = desc }
      @cache
    end
  end

  def self.save_cache
    HOMEBREW_CACHE.mkpath
    CSV.open(CACHE_FILE, 'w') do |csv|
      @cache.each do |name, desc|
        csv << [name, desc]
      end
    end
  end

  # Create a hash mapping all formulae to their descriptions;
  # save it for future use.

  def self.generate_cache
    @cache = {}
    Formula.map do |f|
      @cache[f.full_name] = f.desc
    end
    self.save_cache
  end

  # Create the cache if it doesn't already exist.

  def self.ensure_cache
    self.generate_cache unless self.cache_fresh? && self.cache
  end

  # If the report is empty, just touch the cache file if it exists.
  # Otherwise, if the cache file already exists, use the report to update it.

  def self.update_cache(report)
    if report.empty?
      FileUtils.touch CACHE_FILE if CACHE_FILE.exist?
    elsif self.cache
      alterations = report.select_formula(:A) + report.select_formula(:M)
      alterations.each do |alteration|
        @cache[alteration] = Formula[alteration].desc
      end

      report.select_formula(:D).each do |deleted|
        @cache.delete(deleted)
      end

      self.save_cache
    end
  end

  # Delete the cache.

  def self.delete_cache
    CACHE_FILE.delete if CACHE_FILE.exist?
  end

  # Return true if the cache exists, and neither Homebrew nor any of the Taps
  # repos were updated more recently than it was.

  def self.cache_fresh?
    if CACHE_FILE.exist?
      cache_date = File.mtime(CACHE_FILE)

      ref_master = ".git/refs/heads/master"
      master = HOMEBREW_REPOSITORY/ref_master

      last_update = (master.exist? ? File.mtime(master) : Time.at(0))

      Dir.glob(HOMEBREW_LIBRARY/"Taps/**"/ref_master).each do |repo|
        repo_mtime = File.mtime(repo)
        last_update = repo_mtime if repo_mtime > last_update
      end
      last_update <= cache_date
    end
  end

  # Given an array of formula names, return a hash mapping those names to
  # their descriptions.

  def self.named(names)
    self.ensure_cache

    results = {}
    unless names.empty?
      results = names.inject({}) do |accum, name|
        accum[name] = @cache[name]
        accum
      end
    end

    new(results)
  end

  # Given a regex, find all formulae whose specified fields contain a match for it.

  def self.search(regex, field = :either)
    self.ensure_cache

    results = case field
    when :name
      @cache.select { |name, _| name =~ regex }
    when :desc
      @cache.select { |_, desc| desc =~ regex }
    when :either
      @cache.select { |name, desc| (name =~ regex) || (desc =~ regex) }
    end

    results = Hash[results] if RUBY_VERSION <= "1.8.7"

    new(results)
  end


  def initialize(descriptions)
    @descriptions = descriptions
  end

  # Take search results -- a hash mapping formula names to descriptions -- and
  # print them.

  def print
    blank = "#{Tty.yellow}[no description]#{Tty.reset}"
    @descriptions.keys.sort.each do |name|
      description = @descriptions[name] || blank
      puts "#{Tty.white}#{name}:#{Tty.reset} #{description}"
    end
  end

end
