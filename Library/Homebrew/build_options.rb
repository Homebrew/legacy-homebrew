require 'options'

# This class holds the build-time options defined for a Formula,
# and provides named access to those options during install.
class BuildOptions
  attr_accessor :args
  include Enumerable

  def initialize args
    @args = Options.coerce(args)
    @options = Options.new
  end

  def add name, description=nil
    description ||= case name.to_s
      when "universal" then "Build a universal binary"
      when "32-bit" then "Build 32-bit only"
      end.to_s

    @options << Option.new(name, description)
  end

  def add_dep_option(dep)
    name = dep.name.split("/").last # strip any tap prefix
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

  def with? name
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
    args.include?('--universal') && has_option?('universal')
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

  # Some options are implicitly ON because they are not explictly turned off
  # by their counterpart option. This applies only to with-/without- options.
  # implicit_options are needed because `depends_on 'spam' => 'with-stuff'`
  # complains if 'spam' has stuff as default and only defines `--without-stuff`.
  def implicit_options
    implicit = unused_options.map do |option|
      opposite_of option unless has_opposite_of? option
    end.compact
    Options.new(implicit)
  end

  def has_opposite_of? option
    @options.include? opposite_of(option)
  end

  def opposite_of option
    option = Option.new option
    if option.name =~ /^with-(.+)$/
      Option.new("without-#{$1}")
    elsif option.name =~ /^without-(.+)$/
      Option.new("with-#{$1}")
    elsif option.name =~ /^enable-(.+)$/
      Option.new("disable-#{$1}")
    elsif option.name =~ /^disable-(.+)$/
      Option.new("enable-#{$1}")
    end
  end
end
