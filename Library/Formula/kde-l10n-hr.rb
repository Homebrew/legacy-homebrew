require 'base_kde_formula'

class KdeL10nHr < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-hr-4.10.2.tar.xz'
  sha1 'dbeb1a14b2ea2d55a84f612e46a7fcb944ea2fe5'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-hr-4.10.2.tar.xz'
    sha1 'dbeb1a14b2ea2d55a84f612e46a7fcb944ea2fe5'
  end

  depends_on 'kdelibs'
end
