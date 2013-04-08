require 'base_kde_formula'

class KdeplasmaAddons < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kdeplasma-addons-4.10.2.tar.xz'
  sha1 '26c59eb5738f9efbb94c7109b108ec09d7008ba6'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kdeplasma-addons-4.10.2.tar.xz'
    sha1 '26c59eb5738f9efbb94c7109b108ec09d7008ba6'
  end

  depends_on 'kdelibs'
end
