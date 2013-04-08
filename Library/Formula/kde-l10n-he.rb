require 'base_kde_formula'

class KdeL10nHe < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-he-4.10.2.tar.xz'
  sha1 'a82b82050def365a359dee9d945496261d69ec24'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-he-4.10.2.tar.xz'
    sha1 'a82b82050def365a359dee9d945496261d69ec24'
  end

  depends_on 'kdelibs'
end
