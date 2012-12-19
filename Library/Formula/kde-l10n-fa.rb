require 'base_kde_formula'

class Kde-l10n-fa < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kde-l10n/kde-l10n-fa-4.9.4.tar.xz'
  sha1 '228dbcf8c63675932acb5969321af4f2284dacaa'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kde-l10n/kde-l10n-fa-4.9.95.tar.xz'
    sha1 'c1afaee6eade2b429eeef6877f789355cb99a0fa'
  end

  depends_on 'kdelibs'
end
