require "tap_utils"

module Homebrew
  def tap_pin
    ARGV.named.each do |name|
      tap = Tap.fetch(*tap_args(name))
      tap.pin
      ohai "Pinned #{tap.name}"
    end
  end
end
