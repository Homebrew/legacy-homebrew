require 'base_kde_formula'

class KdeL10nKm < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-km-4.10.2.tar.xz'
  sha1 '59ec9def9bd68d84ce25f469ef3e2ae4379578cf'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-km-4.10.2.tar.xz'
    sha1 '59ec9def9bd68d84ce25f469ef3e2ae4379578cf'
  end

  depends_on 'kdelibs'
end
