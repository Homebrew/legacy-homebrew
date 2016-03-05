require "tap"

module Homebrew
  def untap
    raise "Usage is `brew untap <tap-name>`" if ARGV.empty?

    ARGV.named.each do |tapname|
      tap = Tap.fetch(tapname)
      raise "Homebrew/core is not allowed" if tap.core_formula_repository?
      tap.uninstall
    end
  end
end
