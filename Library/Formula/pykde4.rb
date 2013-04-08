require 'base_kde_formula'

class Pykde4 < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/pykde4-4.10.2.tar.xz'
  sha1 'a17d533fca8126970ec8886f55297f1005df3eb5'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/pykde4-4.10.2.tar.xz'
    sha1 'a17d533fca8126970ec8886f55297f1005df3eb5'
  end

  depends_on 'kdelibs'
end
