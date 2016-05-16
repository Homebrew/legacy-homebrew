require "formula"

module Homebrew
  def log
    if ARGV.named.empty?
      cd HOMEBREW_REPOSITORY
      git_log
    else
      path = Formulary.path(ARGV.named.first)
      cd path.dirname # supports taps
      git_log path
    end
  end

  private

  def git_log(path = nil)
    if File.exist? "#{`git rev-parse --show-toplevel`.chomp}/.git/shallow"
      opoo <<-EOS.undent
        The git repository is a shallow clone therefore the filtering may be incorrect.
        Use `git fetch --unshallow` to get the full repository.
      EOS
    end

    if ARGV.size > 2 then raise <<-EOS.undent
      Usage is:
        brew log formula
      or:
        brew log formula version
    EOS
    end

    args = ARGV.options_only
    args += ["--grep", ARGV[1]] unless ARGV[1].nil?
    args += ["--", path] unless path.nil?
    exec "git", "log", *args
  end
end
