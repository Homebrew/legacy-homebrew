require 'base_kde_formula'

class Kaccessible < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kaccessible-4.9.4.tar.xz'
  sha1 '178b2f10621fbd50b7d4b5d50dfbae012f009551'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kaccessible-4.9.95.tar.xz'
    sha1 'c9fb5b6d2e6cd75f8ae54544ead0c1dc14be50ca'
  end

  depends_on 'kdelibs'
end
