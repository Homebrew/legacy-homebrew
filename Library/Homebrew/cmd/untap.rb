require "cmd/tap" # for tap_args

module Homebrew
  def untap
    raise "Usage is `brew untap <tap-name>`" if ARGV.empty?

    ARGV.named.each do |tapname|
      tap = Tap.fetch(*tap_args(tapname))
      tap.uninstall
    end
  end
end
