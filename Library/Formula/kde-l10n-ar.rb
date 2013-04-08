require 'base_kde_formula'

class KdeL10nAr < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-ar-4.10.2.tar.xz'
  sha1 '30b6f871c515218917116a2254a603546410c296'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-ar-4.10.2.tar.xz'
    sha1 '30b6f871c515218917116a2254a603546410c296'
  end

  depends_on 'kdelibs'
end
