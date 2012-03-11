require 'base_kde_formula'

class Ukiten < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/kiten-4.8.1.tar.xz'
  sha1 'c2c165f4bc89bcbe3a6b49eb06231d4bf85132f0'

  depends_on 'kdelibs'
end


