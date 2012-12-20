require 'base_kde_formula'

class KdeL10nBg < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kde-l10n/kde-l10n-bg-4.9.4.tar.xz'
  sha1 '8c28a1122b9b9b30fe870047ae98ea0d4a28fb31'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kde-l10n/kde-l10n-bg-4.9.95.tar.xz'
    sha1 '7ca20f30dd417a4e36b8e16c00a8b297d578fb29'
  end

  depends_on 'kdelibs'
end
