require 'base_kde_formula'

class KdeL10nNb < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-nb-4.10.2.tar.xz'
  sha1 '2e18e08d1194171449fecfc01427a0b62ff10d0f'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-nb-4.10.2.tar.xz'
    sha1 '2e18e08d1194171449fecfc01427a0b62ff10d0f'
  end

  depends_on 'kdelibs'
end
