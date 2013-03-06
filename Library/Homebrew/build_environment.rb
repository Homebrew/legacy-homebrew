require 'set'

class BuildEnvironment
  def initialize(*settings)
    @settings = Set.new(settings)
    @procs = Set.new
  end

  def <<(o)
    case o
    when Proc then @procs << o
    else @settings << o
    end
    self
  end

  def std?
    @settings.include? :std
  end

  def userpaths?
    @settings.include? :userpaths
  end

  def modify_build_environment(context=nil)
    @procs.each { |p| ENV.instance_exec(context, &p) }
  end

  def _dump(*)
    @settings.to_a.join(":")
  end

  def self._load(s)
    new(*s.split(":").map(&:to_sym))
  end
end

module BuildEnvironmentDSL
  def env(*settings, &block)
    @env ||= BuildEnvironment.new
    if block_given?
      @env << block
    else
      settings.each { |s| @env << s }
    end
    @env
  end
end
