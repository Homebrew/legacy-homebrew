require 'base_kde_formula'

class KdeL10nKk < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-kk-4.10.2.tar.xz'
  sha1 'd435be4020241cb0ecc034f4c26cc928391f84ed'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-kk-4.10.2.tar.xz'
    sha1 'd435be4020241cb0ecc034f4c26cc928391f84ed'
  end

  depends_on 'kdelibs'
end
