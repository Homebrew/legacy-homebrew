require 'base_kde_formula'

class KdeWallpapers < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kde-wallpapers-4.9.4.tar.xz'
  sha1 '02c8d13d884423a66aa04b63e7f99d274cfe683d'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kde-wallpapers-4.9.95.tar.xz'
    sha1 'd4ff36f43825bf2684e1026502988f5fd090da13'
  end

  depends_on 'kdelibs'
end
