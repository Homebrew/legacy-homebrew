require 'base_kde_formula'

class Ukgeography < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/kgeography-4.8.1.tar.xz'
  sha1 '58b526d3a597cc2afff49f431a78864d36842ef2'

  depends_on 'kdelibs'
end


