require "tap"

module Homebrew
  def tap_pin
    ARGV.named.each do |name|
      tap = Tap.fetch(name)
      raise "#{tap} is not allowed" if tap.core_tap?
      tap.pin
      ohai "Pinned #{tap}"
    end
  end
end
