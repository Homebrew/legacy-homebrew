require 'base_kde_formula'

class KdeL10nLv < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kde-l10n/kde-l10n-lv-4.9.4.tar.xz'
  sha1 '50155d2e407d39a7e9bbadd39bd5d1d2d42c63da'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kde-l10n/kde-l10n-lv-4.9.95.tar.xz'
    sha1 'e9e3ac629b97bae5c46dcc7ec380a473f2fa8ceb'
  end

  depends_on 'kdelibs'
end
