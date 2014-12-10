module Homebrew
  def log
    if ARGV.named.empty?
      cd HOMEBREW_REPOSITORY
      exec "git", "log", *ARGV.options_only
    else
      begin
        path = ARGV.formulae.first.path
      rescue FormulaUnavailableError
        # Maybe the formula was deleted
        path = Formula.path(ARGV.named.first)
      end
      cd path.dirname # supports taps
      exec "git", "log", *ARGV.options_only + ["--", path]
    end
  end
end
