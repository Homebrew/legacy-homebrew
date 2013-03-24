module Homebrew extend self
  def log
    path = "."
    if ARGV.named.empty?
      cd HOMEBREW_REPOSITORY
    else
      path = ARGV.formulae.first.path.realpath
      cd path.dirname # supports taps
    end
    if block_given?
      yield path
    else
      exec "git", "log", *ARGV.options_only + [path]
    end
  end
end
