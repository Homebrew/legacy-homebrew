require 'base_kde_formula'

class Kde-l10n-wa < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kde-l10n/kde-l10n-wa-4.9.4.tar.xz'
  sha1 '228bcd6232a2d172045819c40cfa9825d7a5eeb0'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kde-l10n/kde-l10n-wa-4.9.95.tar.xz'
    sha1 'c8c3d43ce59491dc884b6a702434fff53d21faac'
  end

  depends_on 'kdelibs'
end
