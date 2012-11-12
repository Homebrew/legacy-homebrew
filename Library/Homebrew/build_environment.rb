require 'set'

class BuildEnvironment
  def initialize settings
    @settings = Set.new(settings)
  end

  def std?
    @settings.include? :std
  end

  def userpaths?
    @settings.include? :userpaths
  end
end
