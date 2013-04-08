require 'base_kde_formula'

class KdegraphicsMobipocket < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kdegraphics-mobipocket-4.10.2.tar.xz'
  sha1 '657d912c5addd8b770309f125a16d6bd852141ac'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kdegraphics-mobipocket-4.10.2.tar.xz'
    sha1 '657d912c5addd8b770309f125a16d6bd852141ac'
  end

  depends_on 'kdelibs'
end
