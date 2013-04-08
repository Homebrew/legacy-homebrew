require 'base_kde_formula'

class KdeL10nPt < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-pt-4.10.2.tar.xz'
  sha1 '6348ef58dd05eb9365258403e40650e454fd6fab'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-pt-4.10.2.tar.xz'
    sha1 '6348ef58dd05eb9365258403e40650e454fd6fab'
  end

  depends_on 'kdelibs'
end
