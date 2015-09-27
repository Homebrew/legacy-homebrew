require "cmd/tap" # for tap_args
require "descriptions"

module Homebrew
  def untap
    raise "Usage is `brew untap <tap-name>`" if ARGV.empty?

    ARGV.named.each do |tapname|
      tap = Tap.fetch(*tap_args(tapname))

      raise TapUnavailableError, tap.name unless tap.installed?
      puts "Untapping #{tap}... (#{tap.path.abv})"

      tap.unpin if tap.pinned?

      formula_count = tap.formula_files.size
      Descriptions.uncache_formulae(tap.formula_names)
      tap.path.rmtree
      tap.path.dirname.rmdir_if_possible
      puts "Untapped #{formula_count} formula#{plural(formula_count, "e")}"
    end
  end
end
