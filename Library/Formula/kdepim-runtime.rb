require 'base_kde_formula'

class Ukdepim-runtime < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/kdepim-runtime-4.8.1.tar.xz'
  sha1 '2e2e5f1dbfd1b54f0e2b71f9f23be2cfa94348f2'

  depends_on 'kdelibs'
end


