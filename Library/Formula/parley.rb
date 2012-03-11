require 'base_kde_formula'

class Uparley < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/parley-4.8.1.tar.xz'
  sha1 '65cb2a02e5da3d9f1f9bb5a2017743b116bce1cb'

  depends_on 'kdelibs'
end


