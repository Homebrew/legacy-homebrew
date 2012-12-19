require 'base_kde_formula'

class Kde-l10n-tg < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kde-l10n/kde-l10n-tg-4.9.4.tar.xz'
  sha1 '878123332b1e5da07fd94c37797c689635cf5e2a'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kde-l10n/kde-l10n-tg-4.9.95.tar.xz'
    sha1 '2b5f53976d27bda9abaa02fbfbeb139acaadc5be'
  end

  depends_on 'kdelibs'
end
