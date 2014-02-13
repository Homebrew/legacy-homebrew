require 'formula'

module Homebrew extend self
  def reserve
    raise FormulaUnspecifiedError if ARGV.named.empty?

    ARGV.formulae.each do |f|
      if f.installed?
        path = Pathname.new(HOMEBREW_CELLAR/f.name/'.reserved')
        if path.exist?
          opoo "#{f.name} already reserved"
        else
          path.open "w"
        end
      else
        opoo "#{f.name} not installed"
      end
    end
  end
end

