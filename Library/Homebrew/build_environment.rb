require 'set'

class BuildEnvironment
  def initialize(*settings)
    @settings = Set.new(*settings)
  end

  def merge(*args)
    @settings.merge(*args)
    self
  end

  def <<(o)
    @settings << o
    self
  end

  def std?
    @settings.include? :std
  end

  def userpaths?
    @settings.include? :userpaths
  end
end

module BuildEnvironmentDSL
  def env(*settings)
    @env ||= BuildEnvironment.new
    @env.merge(settings)
  end
end
