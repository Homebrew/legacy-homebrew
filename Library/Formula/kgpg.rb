require 'base_kde_formula'

class Kgpg < BaseKdeFormula
  url 'http://download.kde.org/stable/4.8.0/src/kgpg-4.8.0.tar.bz2'
  homepage 'http://utils.kde.org/projects/kgpg/'
  md5 'c19858c68f9a209ae521d7fb3c34747b'
  depends_on 'kdelibs'
  depends_on 'kde-runtime'
end
