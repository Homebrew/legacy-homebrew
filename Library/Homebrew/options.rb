require "set"

class Option
  attr_reader :name, :description, :flag

  def initialize(name, description = "")
    @name = name
    @flag = "--#{name}"
    @description = description
  end

  def to_s
    flag
  end

  def <=>(other)
    return unless Option === other
    name <=> other.name
  end

  def ==(other)
    instance_of?(other.class) && name == other.name
  end
  alias_method :eql?, :==

  def hash
    name.hash
  end

  def inspect
    "#<#{self.class.name}: #{flag.inspect}>"
  end
end

class DeprecatedOption
  attr_reader :old, :current

  def initialize(old, current)
    @old = old
    @current = current
  end

  def old_flag
    "--#{old}"
  end

  def current_flag
    "--#{current}"
  end

  def ==(other)
    instance_of?(other.class) && old == other.old && current == other.current
  end
  alias_method :eql?, :==
end

class Options
  include Enumerable

  def self.create(array)
    new array.map { |e| Option.new(e[/^--([^=]+=?)(.+)?$/, 1] || e) }
  end

  def initialize(*args)
    @options = Set.new(*args)
  end

  def each(*args, &block)
    @options.each(*args, &block)
  end

  def <<(o)
    @options << o
    self
  end

  def +(o)
    self.class.new(@options + o)
  end

  def -(o)
    self.class.new(@options - o)
  end

  def &(o)
    self.class.new(@options & o)
  end

  def |(o)
    self.class.new(@options | o)
  end

  def *(arg)
    @options.to_a * arg
  end

  def empty?
    @options.empty?
  end

  def as_flags
    map(&:flag)
  end

  def include?(o)
    any? { |opt| opt == o || opt.name == o || opt.flag == o }
  end

  alias_method :to_ary, :to_a

  def inspect
    "#<#{self.class.name}: #{to_a.inspect}>"
  end
end

module Homebrew
  def dump_options_for_formula(f)
    f.options.sort_by(&:flag).each do |opt|
      puts "#{opt.flag}\n\t#{opt.description}"
    end
    puts "--devel\n\tInstall development version #{f.devel.version}" if f.devel
    puts "--HEAD\n\tInstall HEAD version" if f.head
  end
end
