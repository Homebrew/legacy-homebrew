require 'base_kde_formula'

class KdeL10nPa < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-pa-4.10.2.tar.xz'
  sha1 '59818bb999de4efb70d8a1fcd203beb542299ef5'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-pa-4.10.2.tar.xz'
    sha1 '59818bb999de4efb70d8a1fcd203beb542299ef5'
  end

  depends_on 'kdelibs'
end
