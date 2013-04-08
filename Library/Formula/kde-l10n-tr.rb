require 'base_kde_formula'

class KdeL10nTr < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-tr-4.10.2.tar.xz'
  sha1 'bb3b1c56e294138098e043ee1313979b858ab80c'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-tr-4.10.2.tar.xz'
    sha1 'bb3b1c56e294138098e043ee1313979b858ab80c'
  end

  depends_on 'kdelibs'
end
