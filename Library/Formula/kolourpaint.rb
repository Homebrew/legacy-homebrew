require 'base_kde_formula'

class Kolourpaint < BaseKdeFormula
  url 'http://download.kde.org/stable/4.8.0/src/kolourpaint-4.8.0.tar.bz2'
  homepage 'http://www.kolourpaint.org/'
  md5 '3b5f5f0d008a1e19e08bcea85ed33dde'

  depends_on 'kdelibs'
  depends_on 'kde-runtime'
end
