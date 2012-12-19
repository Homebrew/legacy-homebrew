require 'base_kde_formula'

class Kde-l10n-fr < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kde-l10n/kde-l10n-fr-4.9.4.tar.xz'
  sha1 '7a436bd50fa6e9c96425ee0bd28908cacd9c1ace'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kde-l10n/kde-l10n-fr-4.9.95.tar.xz'
    sha1 'e52190595f017b3bc4003aada2875d7c67c633d4'
  end

  depends_on 'kdelibs'
end
