require 'formula'

module Homebrew extend self
  def unpin
    if Process.uid.zero? and not File.stat(HOMEBREW_BREW_FILE).uid.zero?
      abort "Cowardly refusing to `sudo unpin'"
    end
    raise FormulaUnspecifiedError if ARGV.named.empty?
    ARGV.formulae.each do |fmla|
      f = Formula.factory(fmla.to_s)
      onoe "Cannot unpin uninstalled formula #{f.name}!" unless f.pinable?
      opoo "Formula #{f.name} already unpinned!" if f.pinable? and not f.pinned?
      f.unpin if f.pinable? and f.pinned?
    end
  end
end
