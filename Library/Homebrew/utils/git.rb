module Utils
  def self.git_available?
    return @git if instance_variable_defined?(:@git)
    git = which("git")
    # git isn't installed by older Xcodes
    return @git = false if git.nil?
    # /usr/bin/git is a popup stub when Xcode/CLT aren't installed, so bail out
    return @git = false if git == "/usr/bin/git" && !OS::Mac.has_apple_developer_tools?
    # check git is real in case it's the wrapper script of Library/ENV/scm
    @git = quiet_system git, "--version"
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
