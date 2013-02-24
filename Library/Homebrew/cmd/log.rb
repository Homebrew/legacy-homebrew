module Homebrew extend self
  def log
    if ARGV.named.empty?
      cd HOMEBREW_REPOSITORY
      exec "git", "log", *ARGV.options_only
    else
      path = ARGV.formulae.first.path.realpath
      cd path.dirname # supports taps
      exec "git", "log", *ARGV.options_only + [path]
    end
  end
end
