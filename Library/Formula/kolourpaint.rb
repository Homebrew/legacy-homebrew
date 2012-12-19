require 'base_kde_formula'

class Kolourpaint < BaseKdeFormula
  homepage 'http://www.kolourpaint.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kolourpaint-4.9.4.tar.xz'
  sha1 '04025967d768683ad9f310aab301b41cb000f51b'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kolourpaint-4.9.95.tar.xz'
    sha1 'bb307d0fc805a32d0adcc593fefcb45107005a45'
  end

  depends_on 'kdelibs'
  depends_on 'kde-runtime'
end
