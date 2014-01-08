require 'formula'

module Homebrew extend self
  def pin
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
