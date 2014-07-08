require 'set'

class BuildEnvironment
  attr_accessor :proc

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

  def modify_build_environment(receiver)
    receiver.instance_eval(&proc) if self.proc
  end

  def marshal_dump
    @settings
  end

  def marshal_load(data)
    @settings = data
  end

  def _dump(*)
    Marshal.dump(marshal_dump)
  end

  def self._load(s)
    new(Marshal.load(s))
  end
end

module BuildEnvironmentDSL
  def env(*settings, &block)
    @env ||= BuildEnvironment.new
    if block_given?
      @env.proc = block
    else
      @env.merge(settings)
    end
    @env
  end
end
