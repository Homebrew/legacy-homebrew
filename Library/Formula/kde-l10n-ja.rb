require 'base_kde_formula'

class KdeL10nJa < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-ja-4.10.2.tar.xz'
  sha1 'c2a846fbdebc436aff9f8131d0b3ee77049cd873'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-ja-4.10.2.tar.xz'
    sha1 'c2a846fbdebc436aff9f8131d0b3ee77049cd873'
  end

  depends_on 'kdelibs'
end
