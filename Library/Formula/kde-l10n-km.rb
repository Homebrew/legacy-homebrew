require 'base_kde_formula'

class Kde-l10n-km < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kde-l10n/kde-l10n-km-4.9.4.tar.xz'
  sha1 'af9ed3be5429ac4fb0a3d98766d7067d93ba602e'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kde-l10n/kde-l10n-km-4.9.95.tar.xz'
    sha1 'c11e70e454b4c5e48c5d5e39f7da50ef8a629a42'
  end

  depends_on 'kdelibs'
end
