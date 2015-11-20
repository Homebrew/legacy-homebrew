require "options"

module Dependable
  RESERVED_TAGS = [:build, :optional, :recommended, :run]

  RESERVED_TAGS.each do |tag|
    method_name = "#{tag}?"

    define_method method_name do
      tags.include? tag
    end
  end

  def required?
    !build? && !optional? && !recommended?
  end

  def options
    Options.create(tags - RESERVED_TAGS)
  end
end
