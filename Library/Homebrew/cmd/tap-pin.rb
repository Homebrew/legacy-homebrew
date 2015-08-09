require "cmd/tap"

module Homebrew
  def tap_pin
    taps = ARGV.named.map do |name|
      Tap.new(*tap_args(name))
    end
    taps.each do |tap|
      tap.pin
      ohai "Pinned #{tap.name}"
    end
  end
end
