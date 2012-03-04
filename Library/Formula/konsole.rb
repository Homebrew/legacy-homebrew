require 'base_kde_formula'

class Konsole < BaseKdeFormula
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.0/src/konsole-4.8.0.tar.bz2'
  homepage 'http://konsole.kde.org/'
  #md5 'c3828a382cb83b8d3c4e1ffcedb16172'
  depends_on 'kdelibs'
  depends_on 'kde-runtime'
end
