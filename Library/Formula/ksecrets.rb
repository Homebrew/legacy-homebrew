require 'base_kde_formula'

class Uksecrets < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/ksecrets-4.8.1.tar.xz'
  sha1 '7ff7889da899dbac86ae63b0e25c2a8cde59fc32'

  depends_on 'kdelibs'
end


