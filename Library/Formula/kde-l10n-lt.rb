require 'base_kde_formula'

class KdeL10nLt < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kde-l10n/kde-l10n-lt-4.9.4.tar.xz'
  sha1 'c8ca573dd6cfa5abcb230ba9831fd0621428e42d'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kde-l10n/kde-l10n-lt-4.9.95.tar.xz'
    sha1 'd232fbb130716af17aa3c658580fc03bd70aac74'
  end

  depends_on 'kdelibs'
end
