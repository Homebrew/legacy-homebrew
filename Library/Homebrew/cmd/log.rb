require "formula"

module Homebrew
  def log
    if ARGV.named.empty?
      cd HOMEBREW_REPOSITORY
      exec "git", "log", *ARGV.options_only
    else
      path = Formulary.path(ARGV.named.first)
      cd path.dirname # supports taps
      exec "git", "log", *ARGV.options_only + ["--", path]
    end
  end
end
