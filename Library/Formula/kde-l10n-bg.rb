require 'base_kde_formula'

class KdeL10nBg < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-bg-4.10.2.tar.xz'
  sha1 '892d115a014021049ab9cca9847a11813b6461f9'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-bg-4.10.2.tar.xz'
    sha1 '892d115a014021049ab9cca9847a11813b6461f9'
  end

  depends_on 'kdelibs'
end
