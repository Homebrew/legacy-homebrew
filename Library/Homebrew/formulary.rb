require "digest/md5"

# The Formulary is responsible for creating instances of Formula.
# It is not meant to be used directy from formulae.

class Formulary
  FORMULAE = {}

  def self.formula_class_defined?(path)
    FORMULAE.key?(path)
  end

  def self.formula_class_get(path)
    FORMULAE.fetch(path)
  end

  def self.load_formula(name, path)
    mod = Module.new
    const_set("FormulaNamespace#{Digest::MD5.hexdigest(path.to_s)}", mod)
    contents = path.open("r") { |f| set_encoding(f).read }
    mod.module_eval(contents, path)
    class_name = class_s(name)

    begin
      klass = mod.const_get(class_name)
    rescue NameError => e
      raise FormulaUnavailableError, name, e.backtrace
    else
      FORMULAE[path] = klass
    end
  end

  if IO.method_defined?(:set_encoding)
    def self.set_encoding(io)
      io.set_encoding(Encoding::UTF_8)
    end
  else
    def self.set_encoding(io)
      io
    end
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

    def initialize(name, path)
      @name = name
      @path = path.resolved_path
    end

    # Gets the formula instance.
    def get_formula(spec)
      klass.new(name, path, spec)
    end

    def klass
      load_file unless Formulary.formula_class_defined?(path)
      Formulary.formula_class_get(path)
    end

    private

    def load_file
      STDERR.puts "#{$0} (#{self.class.name}): loading #{path}" if ARGV.debug?
      raise FormulaUnavailableError.new(name) unless path.file?
      Formulary.load_formula(name, path)
    end
  end

  # Loads formulae from bottles.
  class BottleLoader < FormulaLoader
    def initialize bottle_name
      @bottle_filename = Pathname(bottle_name).realpath
      name, full_name = bottle_resolve_formula_names @bottle_filename
      super name, Formulary.path(full_name)
    end

    def get_formula(spec)
      formula = super
      formula.local_bottle_path = @bottle_filename
      formula
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

    def load_file
      HOMEBREW_CACHE_FORMULA.mkpath
      FileUtils.rm_f(path)
      curl url, "-o", path
      super
    end
  end

  # Loads tapped formulae.
  class TapLoader < FormulaLoader
    attr_reader :tapped_name

    def initialize tapped_name
      @tapped_name = tapped_name
      user, repo, name = tapped_name.split("/", 3).map(&:downcase)
      tap = Tap.new user, repo
      path = tap.formula_files.detect { |file| file.basename(".rb").to_s == name }
      path ||= tap.path/"#{name}.rb"

      super name, path
    end

    def get_formula(spec)
      super
    rescue FormulaUnavailableError => e
      raise TapFormulaUnavailableError, tapped_name, e.backtrace
    end
  end

  class NullLoader < FormulaLoader
    def initialize(name)
      super name, Formulary.core_path(name)
    end

    def get_formula(spec)
      raise FormulaUnavailableError.new(name)
    end
  end

  # Return a Formula instance for the given reference.
  # `ref` is string containing:
  # * a formula name
  # * a formula pathname
  # * a formula URL
  # * a local bottle reference
  def self.factory(ref, spec=:stable, behavior=FactoryBehavior::KEG_FIRST)
    spec = spec || :stable
    loader_for(ref, behavior).get_formula(spec)
  end

  # Return a Formula instance for the given rack.
  def self.from_rack(rack, spec=:stable)
    kegs = rack.directory? ? rack.subdirs.map { |d| Keg.new(d) } : []

    keg = kegs.detect(&:linked?) || kegs.detect(&:optlinked?) || kegs.max_by(&:version)
    return factory(rack.basename.to_s, spec) unless keg

    tap = Tab.for_keg(keg).tap

    if tap.nil? || tap == "Homebrew/homebrew" || tap == "mxcl/master"
      factory(rack.basename.to_s, spec, FactoryBehavior::CORE_ONLY)
    else
      factory("#{tap.sub("homebrew-", "")}/#{rack.basename}", spec, FactoryBehavior::ENFORCE_UNIQUE)
    end
  end

  def self.canonical_name(ref)
    loader_for(ref).name
  rescue TapFormulaAmbiguityError
    # If there are multiple tap formulae with the name of ref,
    # then ref is the canonical name
    ref.downcase
  end

  def self.path(ref)
    loader_for(ref).path
  end

  def self.loader_for(ref, behavior = FactoryBehavior::KEG_FIRST)
    case ref
    when %r[(https?|ftp)://]
      return FromUrlLoader.new(ref)
    when Pathname::BOTTLE_EXTNAME_RX
      return BottleLoader.new(ref)
    when HOMEBREW_CORE_FORMULA_REGEX
      return FormulaLoader.new($1, core_path($1))
    when HOMEBREW_TAP_FORMULA_REGEX
      return TapLoader.new(ref)
    end

    if behavior == FactoryBehavior::CORE_ONLY
      return FormulaLoader.new(ref, core_path(ref))
    end

    if File.extname(ref) == ".rb"
      return FromPathLoader.new(ref)
    end

    formula_with_that_name = find_with_priority(ref, behavior)
    if formula_with_that_name
      return FormulaLoader.new(ref, formula_with_that_name)
    end

    possible_alias = Pathname.new("#{HOMEBREW_LIBRARY}/Aliases/#{ref}")
    if possible_alias.file?
      return AliasLoader.new(possible_alias)
    end

    # possible_tap_formulae = tap_paths(ref)
    # if possible_tap_formulae.size > 1
    #   raise TapFormulaAmbiguityError.new(ref, possible_tap_formulae)
    # elsif possible_tap_formulae.size == 1
    #   return FormulaLoader.new(ref, possible_tap_formulae.first)
    # end

    possible_cached_formula = Pathname.new("#{HOMEBREW_CACHE_FORMULA}/#{ref}.rb")
    if possible_cached_formula.file?
      return FormulaLoader.new(ref, possible_cached_formula)
    end

    return NullLoader.new(ref)
  end

  def self.find_with_priority(ref, behavior)
    available_formulas = tap_paths(ref)
    core_formula = core_path(ref)
    if core_formula.file?
      available_formulas[Tap.core_priority] = [] if available_formulas[Tap.core_priority].nil?
      available_formulas[Tap.core_priority] << core_formula
    end
    unless available_formulas.empty?
      if behavior == FactoryBehavior::ENFORCE_UNIQUE
        flat_formulas = available_formulas.values.flatten
        if flat_formulas.length == 1
          return flat_formulas.first
        else
          raise TapFormulaAmbiguityError.new(ref, flat_formulas)
        end
      else
        if available_formulas.length > 1
          opoo "Some formulae are excluded due to priority settings. Run brew info #{ref} to see them."
        end
        available_formulas.keys.sort.each do |this_priority|
          if available_formulas[this_priority].length > 1
            if behavior == FactoryBehavior::INSTALL_LIKE
              ohai "Multiple formulae with same name and priority available."
              formulae_list = available_formulas[this_priority]
              puts_columns (0..formulae_list.length-1).map { |i| "#{i+1}. #{formulae_list[i].fully_qualified_name}"}
              print "Please choose one by inputing the number before it: "
              selected_index = $stdin.readline.to_i - 1
              ohai "Installing #{available_formulas[this_priority][selected_index].fully_qualified_name}"
            elsif behavior == FactoryBehavior::CHOOSE_ANY
              selected_index = 0
            else
              raise TapFormulaAmbiguityError.new(ref, available_formulas[this_priority])
            end
          else
            selected_index = 0
          end
          return available_formulas[this_priority][selected_index]
        end
      end
    end

  end

  def self.core_path(name)
    Pathname.new("#{HOMEBREW_LIBRARY}/Formula/#{name.downcase}.rb")
  end

  def self.tap_paths(name)
    available_formulas = Hash.new
    name = name.downcase
    # Dir["#{HOMEBREW_LIBRARY}/Taps/*/*/"].map do |tap|
    #   Pathname.glob([
    #     "#{tap}Formula/#{name}.rb",
    #     "#{tap}HomebrewFormula/#{name}.rb",
    #     "#{tap}#{name}.rb",
    #   ]).detect(&:file?)
    # end.compact

    Tap.each do |tap|
      this_priority = tap.get_priority
      tap_path = tap.path
      Pathname.glob(["#{tap_path}/#{name}.rb", "#{tap_path}/Formula/#{name}.rb", "#{tap_path}/HomebrewFormula/#{name}.rb"]) do |formula|
        if formula.file?
          available_formulas[this_priority] = [] if available_formulas[this_priority].nil?
          available_formulas[this_priority] << formula
        end
      end
    end
    available_formulas
  end
end
