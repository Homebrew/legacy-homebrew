require 'base_kde_formula'

class KdeplasmaAddons < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kdeplasma-addons-4.9.4.tar.xz'
  sha1 '112e6702e16d0e40c6422c89227a25c2c4993df3'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kdeplasma-addons-4.9.95.tar.xz'
    sha1 '014576fb2ee8e8b6d57a5e38ef17405b6afdb940'
  end

  depends_on 'kdelibs'
end
