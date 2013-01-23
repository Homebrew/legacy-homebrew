class Option
  include Comparable

  attr_reader :name, :description, :flag

  def initialize(name, description=nil)
    @name = name.to_s[/^(?:--)?(.+)$/, 1]
    @description = description.to_s
    @flag = "--#{@name}"
  end

  def to_s
    flag
  end
  alias_method :to_str, :to_s

  def to_json
    flag.inspect
  end

  def <=>(other)
    name <=> other.name
  end

  def eql?(other)
    other.is_a?(self.class) && hash == other.hash
  end

  def hash
    name.hash
  end
end

class Options
  include Enumerable

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
    Options.new(@options + o)
  end

  def -(o)
    Options.new(@options - o)
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

  def to_a
    @options.to_a
  end
  alias_method :to_ary, :to_a
end
