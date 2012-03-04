require 'base_kde_formula'

class Marble < BaseKdeFormula
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.0/src/marble-4.8.0.tar.bz2'
  homepage 'http://kde.org/'
  md5 '95c546f33706d8fcbef8a04b4b18a17f'

  depends_on 'kdelibs'
end
