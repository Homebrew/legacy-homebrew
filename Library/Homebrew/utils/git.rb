module Utils
  def self.git_available?
    git = which("git")
    # git isn't installed by older Xcodes
    return false if git.nil?
    # /usr/bin/git is a popup stub when Xcode/CLT aren't installed, so bail out
    return false if git == "/usr/bin/git" && !OS::Mac.has_apple_developer_tools?
    true
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
  end
end
