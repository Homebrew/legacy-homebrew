require 'version'

class PkgVersion < Version
  attr_reader :version, :revision

  RX = /\A(.+?)(?:_(\d+))?\z/

  def self.parse(path)
    _, version, revision = *path.match(RX)
    new(version, revision)
  end

  def initialize(version, revision)
    super(version)

    if head?
      @revision = 0
    else
      @revision = revision.to_i
    end
  end

  def to_s
    if revision > 0
      "#{version}_#{revision}"
    else
      version
    end
  end
  alias_method :to_str, :to_s

  def <=>(other)
    super.nonzero? || revision <=> other.revision
  end
end
