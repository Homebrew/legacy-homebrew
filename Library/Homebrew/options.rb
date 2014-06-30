require 'set'

class Option
  include Comparable

  attr_reader :name, :description, :flag

  def initialize(name, description=nil)
    @name, @flag = split_name(name)
    @description = description.to_s
  end

  def to_s
    flag
  end
  alias_method :to_str, :to_s

  def <=>(other)
    return unless Option === other
    name <=> other.name
  end

  def eql?(other)
    instance_of?(other.class) && name == other.name
  end

  def hash
    name.hash
  end

  def inspect
    "#<#{self.class}: #{flag.inspect}>"
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
    Options.new(@options + o)
  end

  def -(o)
    Options.new(@options - o)
  end

  def &(o)
    Options.new(@options & o)
  end

  def |(o)
    Options.new(@options | o)
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

  def concat(o)
    o.each { |opt| @options << opt }
    self
  end

  def to_a
    @options.to_a
  end
  alias_method :to_ary, :to_a

  def inspect
    "#<#{self.class}: #{to_a.inspect}>"
  end

  def self.coerce(arg)
    case arg
    when self then arg
    when Option then new << arg
    when Array
      opts = new
      arg.each do |a|
        case a
        when /^-[^-]+$/
          a[1..-1].split(//).each { |o| opts << Option.new(o) }
        else
          opts << Option.new(a)
        end
      end
      opts
    else
      raise TypeError, "Cannot convert #{arg.inspect} to Options"
    end
  end
end
