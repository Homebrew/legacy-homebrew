require 'base_kde_formula'

class PrintManager < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/print-manager-4.10.2.tar.xz'
  sha1 '67aaa15e157612e50547ce9cd35bcd06ce1fac22'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/print-manager-4.10.2.tar.xz'
    sha1 '67aaa15e157612e50547ce9cd35bcd06ce1fac22'
  end

  depends_on 'kdelibs'
end
