require 'set'

class BuildEnvironment
  def initialize(*settings)
    @settings = Set.new(settings)
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

  def modify_build_environment(context=nil)
    p = @settings.find { |s| Proc === s }
    ENV.instance_exec(context, &p) unless p.nil?
  end

  def _dump(*)
    @settings.dup.reject { |s| Proc === s }.join(":")
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
