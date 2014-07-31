require 'options'

# This class holds the build-time options defined for a Formula,
# and provides named access to those options during install.
class BuildOptions
  include Enumerable

  attr_accessor :args
  attr_accessor :universal
  attr_reader :options
  protected :options

  def initialize args
    @args = Options.coerce(args)
    @options = Options.new
  end

  def initialize_copy(other)
    super
    @options = other.options.dup
    @args = other.args.dup
  end

  def add name, description=nil
    description ||= case name.to_s
      when "universal" then "Build a universal binary"
      when "32-bit" then "Build 32-bit only"
      when "c++11" then "Build using C++11 mode"
      end.to_s

    @options << Option.new(name, description)
  end

  def add_dep_option(dep)
    name = dep.option_name
    if dep.optional? && !has_option?("with-#{name}")
      add("with-#{name}", "Build with #{name} support")
    elsif dep.recommended? && !has_option?("without-#{name}")
      add("without-#{name}", "Build without #{name} support")
    end
  end

  def has_option? name
    any? { |opt| opt.name == name }
  end

  def empty?
    @options.empty?
  end

  def each(*args, &block)
    @options.each(*args, &block)
  end

  def as_flags
    @options.as_flags
  end

  def include? name
    args.include? '--' + name
  end

  def with? val
    if val.respond_to?(:option_name)
      name = val.option_name
    else
      name = val
    end

    if has_option? "with-#{name}"
      include? "with-#{name}"
    elsif has_option? "without-#{name}"
      not include? "without-#{name}"
    else
      false
    end
  end

  def without? name
    not with? name
  end

  def bottle?
    args.include? '--build-bottle'
  end

  def head?
    args.include? '--HEAD'
  end

  def devel?
    args.include? '--devel'
  end

  def stable?
    not (head? or devel?)
  end

  # True if the user requested a universal build.
  def universal?
    universal || args.include?('--universal') && has_option?('universal')
  end

  # True if the user requested to enable C++11 mode.
  def cxx11?
    args.include?('--c++11') && has_option?('c++11')
  end

  # Request a 32-bit only build.
  # This is needed for some use-cases though we prefer to build Universal
  # when a 32-bit version is needed.
  def build_32_bit?
    args.include?('--32-bit') && has_option?('32-bit')
  end

  def used_options
    Options.new(@options & @args)
  end

  def unused_options
    Options.new(@options - @args)
  end
end
