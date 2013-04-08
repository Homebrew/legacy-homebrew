require 'base_kde_formula'

class KdeL10nCs < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-cs-4.10.2.tar.xz'
  sha1 '4161145947ee6721a27f4f46699d5304a70b26f5'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-cs-4.10.2.tar.xz'
    sha1 '4161145947ee6721a27f4f46699d5304a70b26f5'
  end

  depends_on 'kdelibs'
end
