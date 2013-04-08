require 'base_kde_formula'

class KdeL10nHu < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-hu-4.10.2.tar.xz'
  sha1 '1382ad5aa04b99e188e39e3bb33adf3e993764fa'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-hu-4.10.2.tar.xz'
    sha1 '1382ad5aa04b99e188e39e3bb33adf3e993764fa'
  end

  depends_on 'kdelibs'
end
