module Utils
  def self.git_available?
    return @git if instance_variable_defined?(:@git)
    # check git in original path in case it's the wrapper script of Library/ENV/scm
    git = which("git", ORIGINAL_PATHS.join(File::PATH_SEPARATOR))
    # git isn't installed by older Xcodes
    return @git = false if git.nil?
    # /usr/bin/git is a popup stub when Xcode/CLT aren't installed, so bail out
    return @git = false if git == "/usr/bin/git" && !OS::Mac.has_apple_developer_tools?
    @git = true
  end

  def self.ensure_git_installed!
    return if git_available?

    require "cmd/install"
    begin
      oh1 "Installing git"
      Homebrew.perform_preinstall_checks
      Homebrew.install_formula(Formulary.factory("git"))
    rescue
      raise "Git is unavailable"
    end

    raise "Git is unavailable" unless git_available?
  end

  def self.clear_git_available_cache
    remove_instance_variable(:@git) if instance_variable_defined?(:@git)
  end
end
