require 'formula'

module Homebrew extend self
  def pin
    if Process.uid.zero? and not File.stat(HOMEBREW_BREW_FILE).uid.zero?
      abort "Cowardly refusing to `sudo pin'"
    end
    raise FormulaUnspecifiedError if ARGV.named.empty?

    ARGV.formulae.each do |f|
      if f.pinned?
        opoo "#{f.name} already pinned"
      elsif !f.pinnable?
        onoe "#{f.name} not installed"
      else
        f.pin
      end
    end
  end
end
