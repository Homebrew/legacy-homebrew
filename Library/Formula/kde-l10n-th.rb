require 'base_kde_formula'

class KdeL10nTh < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-th-4.10.2.tar.xz'
  sha1 '74187663d61f86d0d44ff42d3256fb2e0a540f54'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-th-4.10.2.tar.xz'
    sha1 '74187663d61f86d0d44ff42d3256fb2e0a540f54'
  end

  depends_on 'kdelibs'
end
