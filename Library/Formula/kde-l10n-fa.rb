require 'base_kde_formula'

class KdeL10nFa < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-fa-4.10.2.tar.xz'
  sha1 '800780529706cff6c95b8910db652ecc88df14f5'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-fa-4.10.2.tar.xz'
    sha1 '800780529706cff6c95b8910db652ecc88df14f5'
  end

  depends_on 'kdelibs'
end
