require 'base_kde_formula'

class KdeL10nPa < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kde-l10n/kde-l10n-pa-4.9.4.tar.xz'
  sha1 '2fa443cd7dc738402bafd83374f2d9c21939806c'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kde-l10n/kde-l10n-pa-4.9.95.tar.xz'
    sha1 'e28c35e9b0ad39461ebb7bcad629319e3df00641'
  end

  depends_on 'kdelibs'
end
