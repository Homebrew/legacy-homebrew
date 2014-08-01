require 'options'

# This class holds the build-time options defined for a Formula,
# and provides named access to those options during install.
class BuildOptions
  include Enumerable

  attr_accessor :args
  attr_accessor :universal
  attr_reader :options

  def initialize(args, options)
    @args = Options.coerce(args)
    @options = options
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

    if option_defined? "with-#{name}"
      include? "with-#{name}"
    elsif option_defined? "without-#{name}"
      not include? "without-#{name}"
    else
      false
    end
  end

  def without? name
    not with? name
  end

  def bottle?
    include? "build-bottle"
  end

  def head?
    include? "HEAD"
  end

  def devel?
    include? "devel"
  end

  def stable?
    not (head? or devel?)
  end

  # True if the user requested a universal build.
  def universal?
    universal || include?("universal") && option_defined?("universal")
  end

  # True if the user requested to enable C++11 mode.
  def cxx11?
    include?("c++11") && option_defined?("c++11")
  end

  # Request a 32-bit only build.
  # This is needed for some use-cases though we prefer to build Universal
  # when a 32-bit version is needed.
  def build_32_bit?
    include?("32-bit") && option_defined?("32-bit")
  end

  def used_options
    Options.new(@options & @args)
  end

  def unused_options
    Options.new(@options - @args)
  end

  private

  def option_defined? name
    @options.include? name
  end
end
