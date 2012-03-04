require 'base_kde_formula'

class Korundum < BaseKdeFormula
  url 'http://download.kde.org/stable/4.8.0/src/korundum-4.8.0.tar.bz2'
  homepage 'http://kde.org'
  #md5 'edfd9bafc3e63dacad63a6c577dcb43c'
  depends_on 'kdelibs'
end
