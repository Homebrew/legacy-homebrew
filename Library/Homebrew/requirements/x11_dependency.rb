require 'requirement'
require 'extend/set'

class X11Dependency < Requirement
  include Comparable
  attr_reader :min_version

  fatal true

  env { ENV.x11 }

  def initialize(name="x11", tags=[])
    @name = name
    @min_version = tags.shift if /(\d\.)+\d/ === tags.first
    super(tags)
  end

  satisfy :build_env => false do
    MacOS::XQuartz.installed? && (@min_version.nil? || @min_version <= MacOS::XQuartz.version)
  end

  def message; <<-EOS.undent
    Unsatisfied dependency: XQuartz #{@min_version}
    Homebrew does not package XQuartz. Installers may be found at:
      https://xquartz.macosforge.org
    EOS
  end

  def <=> other
    return nil unless X11Dependency === other

    if min_version.nil? && other.min_version.nil?
      0
    elsif other.min_version.nil?
      1
    elsif min_version.nil?
      -1
    else
      min_version <=> other.min_version
    end
  end
end
