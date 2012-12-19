require 'base_kde_formula'

class Kstars < BaseKdeFormula
  homepage 'http://edu.kde.org/kstars/'
  url 'http://download.kde.org/stable/4.9.4/src/kstars-4.9.4.tar.xz'
  sha1 'fecf388392ef52b838ae1ce35a76208e28547798'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kstars-4.9.95.tar.xz'
    sha1 '46eed98749a15b29b4a18bc93c2c1c71f1a6ca7d'
  end

  depends_on 'kdelibs'
  depends_on 'kde-runtime'
  depends_on 'eigen'
end
