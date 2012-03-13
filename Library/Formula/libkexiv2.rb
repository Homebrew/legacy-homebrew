require 'base_kde_formula'

class Libkexiv2 < BaseKdeFormula
  homepage 'http://kde.org'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/libkexiv2-4.8.1.tar.xz'
  sha1 '273d76f2414c2dc442ab8f9dc72578977aba0f0c'
  depends_on 'kdelibs'
  depends_on 'exiv2'
end
