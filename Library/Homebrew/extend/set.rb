require 'set'

class ComparableSet < Set
  def add new
    # smileys only
    return super new unless new.respond_to? :>

    objs = find_all { |o| o.class == new.class }
    objs.each do |o|
      return self if o > new
      delete o
    end
    super new
  end

  alias_method :<<, :add

  # Set#merge bypasses enumerating the set's contents,
  # so the subclassed #add would never be called
  def merge enum
    enum.is_a?(Enumerable) or raise ArgumentError, "value must be enumerable"
    enum.each { |o| add(o) }
    self
  end
end
