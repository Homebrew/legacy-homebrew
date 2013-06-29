module Homebrew extend self
  def log
    if ARGV.named.empty?
      cd HOMEBREW_REPOSITORY
      exec "git", "log", *ARGV.options_only
    else
      begin
        path = ARGV.formulae.first.path.realpath
      rescue FormulaUnavailableError
        # Maybe the formula was deleted
        path = HOMEBREW_REPOSITORY/"Library/Formula/#{ARGV.named.first}.rb"
      end
      cd path.dirname # supports taps
      exec "git", "log", *ARGV.options_only + ["--", path]
    end
  end
end
