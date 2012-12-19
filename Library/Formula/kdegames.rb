require 'base_kde_formula'

class Kdegames < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kdegames-4.9.4.tar.xz'
  sha1 '462d1e2e0a833c16d9b2ccbb79c1bf218ecb2e6f'

  depends_on 'kdelibs'
end
