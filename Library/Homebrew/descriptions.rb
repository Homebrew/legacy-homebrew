require "formula"
require "csv"

class Descriptions

  CACHE_FILE=File.join(HOMEBREW_CACHE, "desc_cache")

  def self.cache
    @cache || self.load_cache
  end

  # If the cache file exists, load it into, and return, a hash; otherwise,
  # return nil.

  def self.load_cache
    if File.exist?(CACHE_FILE)
      @cache = {}
      CSV.foreach(CACHE_FILE) { |name, desc| @cache[name] = desc }
      @cache
    end
  end

  # Create a hash mapping all formulae to their descriptions;
  # save it for future use.

  def self.generate_cache
    @cache = {}
    HOMEBREW_CACHE.mkpath
    CSV.open(CACHE_FILE, 'w') do |csv|
      Formula.map do |f|
        name, desc = f.full_name, f.desc
        @cache[name] = desc
        csv << [name, desc]
      end
    end
  end

  # Generate a new copy of the cache, but only if the cache already exists.

  def self.refresh_cache
    self.generate_cache if self.cache
  end

  # Create the cache if it doesn't already exist.

  def self.ensure_cache
    self.generate_cache unless self.cache
  end

  # Delete the cache.

  def self.delete_cache
    File.delete(CACHE_FILE) if File.exist?(CACHE_FILE)
  end

  # Given an array of formula names, return a hash mapping those names to
  # their descriptions. If the array is empty, return a hash of all
  # descriptions.

  def self.named(names)
    self.ensure_cache

    if names.empty?
      results = {}
    else
      results = names.inject({}) do |results, name|
        results[name] = @cache[name]
        results
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
