require 'fileutils'

class FormulaPin
  HOMEBREW_PINNED = HOMEBREW_LIBRARY/'PinnedKegs'

  def initialize(formula)
    @formula = formula
    @name = formula.name
    HOMEBREW_PINNED.mkdir unless HOMEBREW_PINNED.exist?
    @path = HOMEBREW_PINNED/@name
  end

  def pin_at(version)
    version_path = @formula.installed_prefix.parent.join(version)
    FileUtils.ln_s version_path, @path unless pinned? or not version_path.exist?
  end

  def pin
    versions = @formula.installed_prefix.parent.children.map { |item| item.basename.to_s }
    version = versions.map { |item| Version.new(item) }.sort[0].to_s
    pin_at(version)
  end

  def unpin
    FileUtils.rm @path if pinned?
  end

  def pinned?
    @path.symlink?
  end

  def pinable?
    @formula.installed_prefix.parent.children.length > 0
  end
end
