require 'base_kde_formula'

class Kiriki < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kiriki-4.10.2.tar.xz'
  sha1 'f3ec86d168cc21fe22adb610121df62a6280ff1d'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kiriki-4.10.2.tar.xz'
    sha1 'f3ec86d168cc21fe22adb610121df62a6280ff1d'
  end

  depends_on 'kdelibs'
end
