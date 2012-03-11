require 'base_kde_formula'

class Kgpg < BaseKdeFormula
  homepage 'http://utils.kde.org/projects/kgpg/'
  url 'http://download.kde.org/stable/4.8.1/src/kgpg-4.8.1.tar.xz'
  sha1 '40f5bd3f2d4bfeed56e519194c41049e14899e36'

  depends_on 'kdelibs'
  depends_on 'kde-runtime'
end
