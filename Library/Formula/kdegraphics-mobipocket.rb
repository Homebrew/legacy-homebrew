require 'base_kde_formula'

class KdegraphicsMobipocket < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kdegraphics-mobipocket-4.9.4.tar.xz'
  sha1 '11492b62e7691becf2fa1f1e8fb50d341abb7825'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kdegraphics-mobipocket-4.9.95.tar.xz'
    sha1 '715385eab879e22f56b46f73c118b2d94d7dc3d0'
  end

  depends_on 'kdelibs'
end
