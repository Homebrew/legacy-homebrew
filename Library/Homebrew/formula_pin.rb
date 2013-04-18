require 'fileutils'

class FormulaPin
  PINDIR = Pathname.new("#{HOMEBREW_LIBRARY}/PinnedKegs")

  def initialize(f)
    @f = f
  end

  def path
    Pathname.new("#{PINDIR}/#{@f.name}")
  end

  def pin_at(version)
    PINDIR.mkpath unless PINDIR.exist?
    version_path = @f.rack.join(version)
    FileUtils.ln_s(version_path, path) unless pinned? or not version_path.exist?
  end

  def pin
    versions = @f.rack.children.map { |item| item.basename.to_s }
    version = versions.map { |item| Version.new(item) }.sort[0].to_s
    pin_at(version)
  end

  def unpin
    FileUtils.rm(path) if pinned?
  end

  def pinned?
    path.symlink?
  end

  def pinnable?
    @f.rack.exist? && @f.rack.children.length > 0
  end
end
