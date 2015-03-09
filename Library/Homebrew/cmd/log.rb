require "formulary"
require "formula"

module Homebrew
  def log
    if ARGV.named.empty?
      cd HOMEBREW_REPOSITORY
      exec "git", "log", *ARGV.options_only
    else
      begin
        path = Formulary.canonical_path(ARGV.named.first)
      rescue FormulaUnavailableError => e
        # Maybe the formula was deleted
        path = e.expected_path
      end
      cd path.dirname # supports taps
      exec "git", "log", *ARGV.options_only + ["--", path]
    end
  end
end
