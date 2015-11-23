require "cmd/tap"

module Homebrew
  def tap_unpin
    ARGV.named.each do |name|
      tap = Tap.fetch(*tap_args(name))
      tap.unpin
      ohai "Unpinned #{tap.name}"
    end
  end
end
