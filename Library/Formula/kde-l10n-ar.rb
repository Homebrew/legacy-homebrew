require 'base_kde_formula'

class Kde-l10n-ar < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kde-l10n/kde-l10n-ar-4.9.4.tar.xz'
  sha1 '97d7c9e5e2790dc0377ed525077a1a3191461549'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kde-l10n/kde-l10n-ar-4.9.95.tar.xz'
    sha1 '4f674d3f086feb49d65ab180379109cb98f73735'
  end

  depends_on 'kdelibs'
end
