require "version"

class PkgVersion
  include Comparable

  RX = /\A(.+?)(?:_(\d+))?\z/

  def self.parse(path)
    _, version, revision = *path.match(RX)
    version = Version.new(version)
    new(version, revision.to_i)
  end

  def initialize(version, revision)
    @version = version
    @revision = version.head? ? 0 : revision
  end

  def head?
    version.head?
  end

  def to_s
    if revision > 0
      "#{version}_#{revision}"
    else
      version.to_s
    end
  end
  alias_method :to_str, :to_s

  def <=>(other)
    return unless PkgVersion === other
    (version <=> other.version).nonzero? || revision <=> other.revision
  end
  alias_method :eql?, :==

  def hash
    version.hash ^ revision.hash
  end

  protected

  attr_reader :version, :revision
end
