require "tap"

module Homebrew
  def __repository
    if ARGV.named.empty?
      puts HOMEBREW_REPOSITORY
    else
      puts ARGV.named.map { |tap| Tap.fetch(tap).path }
    end
  end
end
