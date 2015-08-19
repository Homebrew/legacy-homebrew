require "cmd/tap"

module Homebrew
  def tap_unpin
    taps = ARGV.named.map do |name|
      Tap.new(*tap_args(name))
    end
    taps.each do |tap|
      tap.unpin
      ohai "Unpinned #{tap.name}"
    end
  end
end
