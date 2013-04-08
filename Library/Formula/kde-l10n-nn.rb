require 'base_kde_formula'

class KdeL10nNn < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-nn-4.10.2.tar.xz'
  sha1 '390f934ff80626cca0cd3c2c73f447d251be1625'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-nn-4.10.2.tar.xz'
    sha1 '390f934ff80626cca0cd3c2c73f447d251be1625'
  end

  depends_on 'kdelibs'
end
