require "tap"

module Homebrew
  def tap_pin
    ARGV.named.each do |name|
      tap = Tap.fetch(name)
      raise "Homebrew/homebrew is not allowed" if tap.core_formula_repository?
      tap.pin
      ohai "Pinned #{tap.name}"
    end
  end
end
