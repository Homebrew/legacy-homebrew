require 'base_kde_formula'

class KdeL10nIa < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-ia-4.10.2.tar.xz'
  sha1 'f8459baf8e61c9627a7efa0a40c70337ab24455d'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-ia-4.10.2.tar.xz'
    sha1 'f8459baf8e61c9627a7efa0a40c70337ab24455d'
  end

  depends_on 'kdelibs'
end
