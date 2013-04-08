require 'base_kde_formula'

class KdegraphicsThumbnailers < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kdegraphics-thumbnailers-4.10.2.tar.xz'
  sha1 '7a3688aa23050967927e569f2b8d8c6841bf2401'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kdegraphics-thumbnailers-4.10.2.tar.xz'
    sha1 '7a3688aa23050967927e569f2b8d8c6841bf2401'
  end

  depends_on 'kdelibs'
end
