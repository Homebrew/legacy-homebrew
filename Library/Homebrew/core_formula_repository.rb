require "tap"

# A specialized {Tap} class for the core formula file system
class CoreFormulaRepository < Tap
  if OS.mac?
    OFFICIAL_REMOTE = "https://github.com/Homebrew/homebrew-core"
  else
    OFFICIAL_REMOTE = "https://github.com/Linuxbrew/homebrew-core"
  end

  # @private
  def initialize
    super "Homebrew", "core"
  end

  def self.instance
    @instance ||= CoreFormulaRepository.new
  end

  def self.ensure_installed!(options = {})
    return if instance.installed?
    args = ["tap", instance.name]
    args << "-q" if options.fetch(:quiet, true)
    safe_system HOMEBREW_BREW_FILE, *args
  end

  # @private
  def install(options = {})
    options = { :clone_target => OFFICIAL_REMOTE }.merge(options)
    super options
  end

  # @private
  def uninstall
    raise "Tap#uninstall is not available for CoreFormulaRepository"
  end

  # @private
  def pin
    raise "Tap#pin is not available for CoreFormulaRepository"
  end

  # @private
  def unpin
    raise "Tap#unpin is not available for CoreFormulaRepository"
  end

  # @private
  def pinned?
    false
  end

  # @private
  def command_files
    []
  end

  # @private
  def custom_remote?
    return true unless remote
    remote != OFFICIAL_REMOTE
  end

  # @private
  def core_formula_repository?
    true
  end

  # @private
  def formula_dir
    self.class.ensure_installed!
    super
  end

  # @private
  def alias_dir
    self.class.ensure_installed!
    super
  end

  # @private
  def formula_renames
    self.class.ensure_installed!
    super
  end

  # @private
  def tap_migrations
    self.class.ensure_installed!
    super
  end

  # @private
  def formula_file_to_name(file)
    file.basename(".rb").to_s
  end

  # @private
  def alias_file_to_name(file)
    file.basename.to_s
  end
end
