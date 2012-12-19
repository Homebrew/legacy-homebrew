require 'base_kde_formula'

class Kde-l10n-ug < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kde-l10n/kde-l10n-ug-4.9.4.tar.xz'
  sha1 'a10bccc15d42b0a6351c9acc7e42f3ac73e88eae'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kde-l10n/kde-l10n-ug-4.9.95.tar.xz'
    sha1 '220a4484d56c3f7a9297b182c1424c3e6e67132c'
  end

  depends_on 'kdelibs'
end
