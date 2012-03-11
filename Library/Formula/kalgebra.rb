require 'base_kde_formula'

class Ukalgebra < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/kalgebra-4.8.1.tar.xz'
  sha1 '79f4c85e93a1d270d9d7ba648b86d49fca42d6fb'

  depends_on 'kdelibs'
end


