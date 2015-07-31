require 'formula'
require 'csv'

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
    CSV.open(CACHE_FILE, 'w') do |csv|
      Formula.map do |f|
        name, desc = f.name, f.desc
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
      @cache
    else
      names.inject({}) do |descriptions, name|
        descriptions[name] = @cache[name]
        descriptions
      end
    end
  end

  # Given a regex, find all formulae whose specified fields contain a match for it.

  def self.matching(regex, field = :either)
    self.ensure_cache

    matchers = {
      :name   => proc { |name, desc| name =~ regex },
      :desc   => proc { |name, desc| desc =~ regex },
      :either => proc { |name, desc| (name =~ regex) || (desc =~ regex) }
    }

    results = @cache.select(&(matchers[field]))

    if RUBY_VERSION <= "1.8.7"
      Hash[results]
    else
      results
    end
  end

  # Take search results -- a hash mapping formula names to descriptions -- and
  # print them.

  def self.print(descriptions)
    blank = "#{Tty.yellow}[no description]#{Tty.reset}"
    descriptions.keys.sort.each do |name|
      description = descriptions[name] || blank
      puts "#{Tty.white}#{name}:#{Tty.reset} #{description}"
    end
  end

end
