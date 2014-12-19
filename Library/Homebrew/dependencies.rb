class Dependencies
  include Enumerable

  def initialize
    @deps = []
  end

  def each(*args, &block)
    @deps.each(*args, &block)
  end

  def <<(o)
    @deps << o
    self
  end

  def empty?
    @deps.empty?
  end

  def *(arg)
    @deps * arg
  end

  alias_method :to_ary, :to_a

  def optional
    select(&:optional?)
  end

  def recommended
    select(&:recommended?)
  end

  def build
    select(&:build?)
  end

  def required
    select(&:required?)
  end

  def default
    build + required + recommended
  end

  attr_reader :deps
  protected :deps

  def ==(other)
    deps == other.deps
  end
  alias_method :eql?, :==

  def inspect
    "#<#{self.class.name}: #{to_a.inspect}>"
  end
end

class Requirements
  include Enumerable

  def initialize
    @reqs = Set.new
  end

  def each(*args, &block)
    @reqs.each(*args, &block)
  end

  def <<(other)
    if Comparable === other
      @reqs.grep(other.class) do |req|
        return self if req > other
        @reqs.delete(req)
      end
    end
    @reqs << other
    self
  end

  alias_method :to_ary, :to_a
end
