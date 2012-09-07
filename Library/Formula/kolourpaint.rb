require 'base_kde_formula'

class Kolourpaint < BaseKdeFormula
  homepage 'http://www.kolourpaint.org/'
  url 'http://download.kde.org/stable/4.8.1/src/kolourpaint-4.8.1.tar.xz'
  sha1 '7a6404f573671b8407a2cf4ec3543ab0883a7af2'

  depends_on 'kdelibs'
  depends_on 'kde-runtime'
end
