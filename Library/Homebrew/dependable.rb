require 'options'

module Dependable
  RESERVED_TAGS = [:build, :optional, :recommended]

  def build?
    tags.include? :build
  end

  def optional?
    tags.include? :optional
  end

  def recommended?
    tags.include? :recommended
  end

  def options
    Options.coerce(tags - RESERVED_TAGS)
  end
end
