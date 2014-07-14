# The Formulary is responsible for creating instances of Formula.
# It is not meant to be used directy from formulae.

class Formulary

  def self.unload_formula formula_name
    Object.send(:remove_const, class_s(formula_name))
  end

  def self.formula_class_defined? class_name
    Object.const_defined?(class_name)
  end

  def self.get_formula_class class_name
    Object.const_get(class_name)
  end

  def self.restore_formula formula_name, value
    old_verbose, $VERBOSE = $VERBOSE, nil
    Object.const_set(class_s(formula_name), value)
  ensure
    $VERBOSE = old_verbose
  end

  def self.class_s name
    class_name = name.capitalize
    class_name.gsub!(/[-_.\s]([a-zA-Z0-9])/) { $1.upcase }
    class_name.gsub!('+', 'x')
    class_name
  end

  # A FormulaLoader returns instances of formulae.
  # Subclasses implement loaders for particular sources of formulae.
  class FormulaLoader
    # The formula's name
    attr_reader :name
    # The formula's ruby file's path or filename
    attr_reader :path
    # The ruby constant name of the formula's class
    attr_reader :class_name

    def initialize(name, path)
      @name = name
      @path = path.resolved_path
      @class_name = Formulary.class_s(name)
    end

    # Gets the formula instance.
    def get_formula(spec)
      klass.new(name, path, spec)
    end

    # Return the Class for this formula, `require`-ing it if
    # it has not been parsed before.
    def klass
      begin
        have_klass = Formulary.formula_class_defined? class_name
      rescue NameError
        raise FormulaUnavailableError.new(name)
      end

      unless have_klass
        STDERR.puts "#{$0} (#{self.class.name}): loading #{path}" if ARGV.debug?
        begin
          require path
        rescue NoMethodError
          # This is a programming error in an existing formula, and should not
          # have a "no such formula" message.
          raise
        rescue LoadError, NameError
          raise if ARGV.debug?  # let's see the REAL error
          raise FormulaUnavailableError.new(name)
        end
      end

      klass = Formulary.get_formula_class(class_name)
      if klass == Formula || !(klass < Formula)
        raise FormulaUnavailableError.new(name)
      end
      klass
    end
  end

  # Loads formulae from bottles.
  class BottleLoader < FormulaLoader
    def initialize bottle_name
      @bottle_filename = Pathname(bottle_name).realpath
      name_without_version = bottle_filename_formula_name @bottle_filename
      if name_without_version.empty?
        if ARGV.homebrew_developer?
          opoo "Add a new regex to bottle_version.rb to parse this filename."
        end
        name = bottle_name
      else
        name = name_without_version
      end

      super name, Formula.path(name)
    end

    def get_formula(spec)
      formula = super
      formula.local_bottle_path = @bottle_filename
      formula
    end
  end

  # Loads formulae from Homebrew's provided Library
  class StandardLoader < FormulaLoader
    def initialize name, path=Formula.path(name)
      super
    end
  end

  class AliasLoader < FormulaLoader
    def initialize alias_path
      path = alias_path.resolved_path
      name = path.basename(".rb").to_s
      super name, path
    end
  end

  # Loads formulae from disk using a path
  class FromPathLoader < FormulaLoader
    def initialize path
      path = Pathname.new(path).expand_path
      super path.basename(".rb").to_s, path
    end
  end

  # Loads formulae from URLs
  class FromUrlLoader < FormulaLoader
    attr_reader :url

    def initialize url
      @url = url
      uri = URI(url)
      formula = File.basename(uri.path, ".rb")
      super formula, HOMEBREW_CACHE_FORMULA/File.basename(uri.path)
    end

    # Downloads the formula's .rb file
    def fetch
      begin
        have_klass = Formulary.formula_class_defined? class_name
      rescue NameError
        raise FormulaUnavailableError.new(name)
      end

      unless have_klass
        HOMEBREW_CACHE_FORMULA.mkpath
        FileUtils.rm path.to_s, :force => true
        curl url, '-o', path.to_s
      end
    end

    def get_formula(spec)
      fetch
      super
    end
  end

  # Loads tapped formulae.
  class TapLoader < FormulaLoader
    attr_reader :tapped_name

    def initialize tapped_name
      @tapped_name = tapped_name
      user, repo, name = tapped_name.split("/", 3).map(&:downcase)
      tap = Pathname.new("#{HOMEBREW_LIBRARY}/Taps/#{user}/homebrew-#{repo}")
      path = tap.join("#{name}.rb")

      if tap.directory?
        tap.find_formula do |file|
          if file.basename(".rb").to_s == name
            path = file
          end
        end
      end

      super name, path
    end

    def get_formula(spec)
      super
    rescue FormulaUnavailableError
      raise TapFormulaUnavailableError.new(tapped_name)
    end
  end

  # Return a Formula instance for the given reference.
  # `ref` is string containing:
  # * a formula name
  # * a formula pathname
  # * a formula URL
  # * a local bottle reference
  def self.factory(ref, spec=:stable)
    loader_for(ref).get_formula(spec)
  end

  def self.canonical_name(ref)
    loader_for(ref).name
  end

  def self.loader_for(ref)
    case ref
    when %r[(https?|ftp)://]
      return FromUrlLoader.new(ref)
    when Pathname::BOTTLE_EXTNAME_RX
      return BottleLoader.new(ref)
    when HOMEBREW_TAP_FORMULA_REGEX
      return TapLoader.new(ref)
    end

    if File.extname(ref) == ".rb"
      return FromPathLoader.new(ref)
    end

    formula_with_that_name = Formula.path(ref)
    if formula_with_that_name.file?
      return StandardLoader.new(ref, formula_with_that_name)
    end

    possible_alias = Pathname.new("#{HOMEBREW_LIBRARY}/Aliases/#{ref}")
    if possible_alias.file?
      return AliasLoader.new(possible_alias)
    end

    possible_cached_formula = Pathname.new("#{HOMEBREW_CACHE_FORMULA}/#{ref}.rb")
    if possible_cached_formula.file?
      return StandardLoader.new(ref, possible_cached_formula)
    end

    return StandardLoader.new(ref)
  end
end
