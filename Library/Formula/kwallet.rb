require 'base_kde_formula'

class Ukwallet < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/kwallet-4.8.1.tar.xz'
  sha1 '39c1d6720cd486e86179468b5606923bab73cb9e'

  depends_on 'kdelibs'
end


