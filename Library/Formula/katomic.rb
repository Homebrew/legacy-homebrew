require 'base_kde_formula'

class Katomic < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/katomic-4.10.2.tar.xz'
  sha1 'c7d3fc2dc10ce90092d229f1a879a0081e26cd8b'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/katomic-4.10.2.tar.xz'
    sha1 'c7d3fc2dc10ce90092d229f1a879a0081e26cd8b'
  end

  depends_on 'kdelibs'
end
