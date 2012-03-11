require 'base_kde_formula'

class Uqtruby < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/qtruby-4.8.1.tar.xz'
  sha1 'b2532f9e9e04760fce5d9ac87768e6085f0c231b'

  depends_on 'kdelibs'
end


