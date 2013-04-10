require 'formula'

module Homebrew extend self
  def pin
    if Process.uid.zero? and not File.stat(HOMEBREW_BREW_FILE).uid.zero?
      abort "Cowardly refusing to `sudo pin'"
    end
    raise FormulaUnspecifiedError if ARGV.named.empty?
    ARGV.formulae.each do |fmla|
      f = Formula.factory(fmla.to_s)
      onoe "Cannot pin uninstalled formula #{f.name}!" unless f.pinable?
      opoo "Formula #{f.name} already pinned!" if f.pinable? and f.pinned?
      f.pin if f.pinable? and not f.pinned?
    end
  end
end
