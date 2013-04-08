require 'base_kde_formula'

class KdeL10nSr < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-sr-4.10.2.tar.xz'
  sha1 '56346b4810f38d1ba7a56e916475ca270fea4d99'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-sr-4.10.2.tar.xz'
    sha1 '56346b4810f38d1ba7a56e916475ca270fea4d99'
  end

  depends_on 'kdelibs'
end
