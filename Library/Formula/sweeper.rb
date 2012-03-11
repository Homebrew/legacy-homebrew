require 'base_kde_formula'

class Usweeper < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/sweeper-4.8.1.tar.xz'
  sha1 '7a11a22397bbe5106118ed94942f27f546fad80b'

  depends_on 'kdelibs'
end


