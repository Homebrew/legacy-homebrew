require 'base_kde_formula'

class KdeL10nUg < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-ug-4.10.2.tar.xz'
  sha1 'f12052214e39cf78db96b1491c244160fc8f2bde'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-ug-4.10.2.tar.xz'
    sha1 'f12052214e39cf78db96b1491c244160fc8f2bde'
  end

  depends_on 'kdelibs'
end
