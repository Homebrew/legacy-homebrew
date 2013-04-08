require 'base_kde_formula'

class KdeL10nLv < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-lv-4.10.2.tar.xz'
  sha1 'b3a40e2adf3666391fe35a76d756dbfbc46960e3'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-lv-4.10.2.tar.xz'
    sha1 'b3a40e2adf3666391fe35a76d756dbfbc46960e3'
  end

  depends_on 'kdelibs'
end
