require 'base_kde_formula'

class KdeBaseapps < BaseKdeFormula
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.0/src/kde-baseapps-4.8.0.tar.bz2'
  homepage 'http://kde.org/'
  #md5 'd44310cad99a9afb757ff13f24eeae32'
  depends_on 'kdelibs'
  depends_on 'kde-runtime'
end
