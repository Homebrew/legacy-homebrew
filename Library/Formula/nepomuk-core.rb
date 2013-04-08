require 'base_kde_formula'

class NepomukCore < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/nepomuk-core-4.10.2.tar.xz'
  sha1 'e17ca2b7eb3b1745806be7576d6340777f4ce0d0'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/nepomuk-core-4.10.2.tar.xz'
    sha1 'e17ca2b7eb3b1745806be7576d6340777f4ce0d0'
  end

  depends_on 'kdelibs'
end
