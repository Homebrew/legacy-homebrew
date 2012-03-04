require 'base_kde_formula'

class Kruler < BaseKdeFormula
  url 'http://download.kde.org/stable/4.8.0/src/kruler-4.8.0.tar.bz2'
  homepage 'http://kde.org'
  #md5 '064505a9c03839225eb04a1604874efb'
  depends_on 'kdelibs'
end
