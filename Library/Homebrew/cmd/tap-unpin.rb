require "tap"

module Homebrew
  def tap_unpin
    ARGV.named.each do |name|
      tap = Tap.fetch(name)
      raise "#{tap} is not allowed" if tap.core_tap?
      tap.unpin
      ohai "Unpinned #{tap}"
    end
  end
end
