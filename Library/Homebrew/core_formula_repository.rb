require "tap"

# A specialized {Tap} class to mimic the core formula file system, which shares many
# similarities with normal {Tap}.
# TODO Separate core formulae with core codes. See discussion below for future plan:
#      https://github.com/Homebrew/homebrew/pull/46735#discussion_r46820565
class CoreFormulaRepository < Tap
  # @private
  def initialize
    @user = "Homebrew"
    @repo = "homebrew"
    @name = "Homebrew/homebrew"
    @path = HOMEBREW_REPOSITORY
  end

  def self.instance
    @instance ||= CoreFormulaRepository.new
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
    remote != "https://github.com/#{user}/#{repo}.git"
  end

  # @private
  def core_formula_repository?
    true
  end

  # @private
  def formula_dir
    HOMEBREW_LIBRARY/"Formula"
  end

  # @private
  def alias_dir
    HOMEBREW_LIBRARY/"Aliases"
  end

  # @private
  def formula_renames
    require "formula_renames"
    FORMULA_RENAMES
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
