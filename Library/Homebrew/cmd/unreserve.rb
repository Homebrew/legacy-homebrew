require 'formula'

module Homebrew extend self
  def unreserve
    raise FormulaUnspecifiedError if ARGV.named.empty?

    ARGV.formulae.each do |f|
      if f.installed?
        path = Pathname.new(HOMEBREW_CELLAR/f.name/'.reserved')
        if path.exist?
          path.unlink
        else
          opoo "#{f.name} not reserved"
        end
      else
        opoo "#{f.name} not installed"
      end
    end
  end
end

