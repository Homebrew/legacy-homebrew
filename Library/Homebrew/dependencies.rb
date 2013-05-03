class Dependencies
  include Enumerable

  def initialize(*args)
    @deps = Array.new(*args)
  end

  def each(*args, &block)
    @deps.each(*args, &block)
  end

  def <<(o)
    @deps << o unless @deps.include? o
    self
  end

  def empty?
    @deps.empty?
  end

  def *(arg)
    @deps * arg
  end

  def to_a
    @deps
  end
  alias_method :to_ary, :to_a
end
