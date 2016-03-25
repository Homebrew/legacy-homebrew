module Utils
  def self.git_available?
    return @git if instance_variable_defined?(:@git)
    @git = quiet_system HOMEBREW_ENV_PATH/"scm/git", "--version"
  end

  def self.ensure_git_installed!
    return if git_available?

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
