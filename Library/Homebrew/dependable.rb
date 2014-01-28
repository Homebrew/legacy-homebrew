require 'options'

module Dependable
  RESERVED_TAGS = [:build, :optional, :recommended, :run]

  def build?
    tags.include? :build
  end

  def optional?
    tags.include? :optional
  end

  def recommended?
    tags.include? :recommended
  end

  def run?
    tags.include? :run
  end

  def required?
    !build? && !optional? && !recommended?
  end

  def options
    Options.coerce(tags - RESERVED_TAGS)
  end
end
