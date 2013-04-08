require 'base_kde_formula'

class KdeL10nWa < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-wa-4.10.2.tar.xz'
  sha1 'c57b66992f86478adcef57fb9be45350b7f3df2e'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-wa-4.10.2.tar.xz'
    sha1 'c57b66992f86478adcef57fb9be45350b7f3df2e'
  end

  depends_on 'kdelibs'
end
