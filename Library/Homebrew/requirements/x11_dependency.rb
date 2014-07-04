require "requirement"

class X11Dependency < Requirement
  include Comparable
  attr_reader :min_version

  fatal true

  env { ENV.x11 }

  def initialize(name="x11", tags=[])
    @name = name
    if /(\d\.)+\d/ === tags.first
      @min_version = Version.new(tags.shift)
    else
      @min_version = Version.new("0.0.0")
    end
    super(tags)
  end

  satisfy :build_env => false do
    MacOS::XQuartz.installed? && min_version <= Version.new(MacOS::XQuartz.version)
  end

  def message; <<-EOS.undent
    Unsatisfied dependency: XQuartz #{@min_version}
    Homebrew does not package XQuartz. Installers may be found at:
      https://xquartz.macosforge.org
    EOS
  end

  def <=> other
    return unless X11Dependency === other
    min_version <=> other.min_version
  end

  def eql?(other)
    super && min_version == other.min_version
  end

  def inspect
    "#<#{self.class.name}: #{name.inspect} #{tags.inspect} min_version=#{min_version}>"
  end
end
