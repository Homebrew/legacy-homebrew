require 'set'

class Option
  attr_reader :name, :description, :flag

  def initialize(name, description="")
    @name, @flag = split_name(name)
    @description = description
  end

  def to_s
    flag
  end
  alias_method :to_str, :to_s

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

  private

  def split_name(name)
    case name
    when /^[a-zA-Z]$/
      [name, "-#{name}"]
    when /^-[a-zA-Z]$/
      [name[1..1], name]
    when /^--(.+)$/
      [$1, name]
    else
      [name, "--#{name}"]
    end
  end
end

class Options
  include Enumerable

  attr_reader :options
  protected :options

  def self.create(array)
    options = new
    array.each do |e|
      case e
      when /^-[^-]+$/
        e[1..-1].split(//).each { |o| options << Option.new(o) }
      else
        options << Option.new(e)
      end
    end
    options
  end

  def initialize(*args)
    @options = Set.new(*args)
  end

  def initialize_copy(other)
    super
    @options = other.options.dup
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
