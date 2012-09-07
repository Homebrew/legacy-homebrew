require 'base_kde_formula'

class Koffice < BaseKdeFormula
  homepage 'http://www.koffice.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/koffice-2.3.3/koffice-2.3.3.tar.bz2'
  md5 '1ebb955d54b6d6032999cc92e4b13bfe'
  depends_on 'kdelibs'
end
