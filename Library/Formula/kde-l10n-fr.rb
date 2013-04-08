require 'base_kde_formula'

class KdeL10nFr < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-fr-4.10.2.tar.xz'
  sha1 '90d5c2e2a9147b157769923726417b482e3bc613'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-fr-4.10.2.tar.xz'
    sha1 '90d5c2e2a9147b157769923726417b482e3bc613'
  end

  depends_on 'kdelibs'
end
