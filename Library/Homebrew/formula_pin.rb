class FormulaPin
  PINDIR = Pathname.new("#{HOMEBREW_LIBRARY}/PinnedKegs")

  def initialize(f)
    @f = f
  end

  def path
    Pathname.new("#{PINDIR}/#{@f.name}")
  end

  def pin_at(version)
    PINDIR.mkpath
    version_path = @f.rack.join(version)
    path.make_relative_symlink(version_path) unless pinned? || !version_path.exist?
  end

  def pin
    versions = @f.rack.children.map { |item| item.basename.to_s }
    version = versions.map { |item| Version.new(item) }.sort[0].to_s
    pin_at(version)
  end

  def unpin
    path.unlink if pinned?
  end

  def pinned?
    path.symlink?
  end

  def pinnable?
    @f.rack.exist? && @f.rack.children.length > 0
  end
end
