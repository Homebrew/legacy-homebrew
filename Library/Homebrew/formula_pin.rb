require "keg"

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
    pin_at(@f.installed_kegs.map { |keg| keg.version }.max)
  end

  def unpin
    path.unlink if pinned?
    PINDIR.rmdir_if_possible
  end

  def pinned?
    path.symlink?
  end

  def pinnable?
    @f.installed_prefixes.any?
  end

  def pinned_version
    Keg.new(path.resolved_path).version if pinned?
  end
end
