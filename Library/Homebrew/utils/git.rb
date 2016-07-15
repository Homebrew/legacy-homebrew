module Utils
  def self.git_available?
    return @git if instance_variable_defined?(:@git)
    @git = quiet_system HOMEBREW_SHIMS_PATH/"scm/git", "--version"
  end

  def self.ensure_git_installed!
    return if git_available?

    # we cannot install brewed git if homebrew/core is unavailable.
    unless CoreTap.instance.installed?
      raise "Git is unavailable"
    end

    begin
      oh1 "Installing git"
      safe_system HOMEBREW_BREW_FILE, "install", "git"
    rescue
      raise "Git is unavailable"
    end

    clear_git_available_cache
    raise "Git is unavailable" unless git_available?
  end

  def self.clear_git_available_cache
    remove_instance_variable(:@git) if instance_variable_defined?(:@git)
  end
end
