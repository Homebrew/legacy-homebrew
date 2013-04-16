require 'formula'

module Homebrew extend self
  def unpin
    if Process.uid.zero? and not File.stat(HOMEBREW_BREW_FILE).uid.zero?
      abort "Cowardly refusing to `sudo unpin'"
    end
    raise FormulaUnspecifiedError if ARGV.named.empty?

    ARGV.formulae.each do |f|
      if f.pinned?
        f.unpin
      elsif !f.pinnable?
        onoe "#{f.name} not installed"
      else
        opoo "#{f.name} not pinned"
      end
    end
  end
end
