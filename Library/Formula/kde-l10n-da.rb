require 'base_kde_formula'

class KdeL10nDa < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-da-4.10.2.tar.xz'
  sha1 'f0af6a830a7f7b8d739abe29908afd1271f31e7f'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-da-4.10.2.tar.xz'
    sha1 'f0af6a830a7f7b8d739abe29908afd1271f31e7f'
  end

  depends_on 'kdelibs'
end
