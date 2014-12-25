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
      @min_version_string = " #{@min_version}"
    else
      @min_version = Version.new("0.0.0")
      @min_version_string = ""
    end
    super(tags)
  end

  satisfy :build_env => false do
    MacOS::XQuartz.installed? && min_version <= Version.new(MacOS::XQuartz.version)
  end

  def message; <<-EOS.undent
    You can install XQuartz#{@min_version_string} with:
      brew cask install xquartz

    Or from:
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
