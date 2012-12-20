require 'base_kde_formula'

class KdeL10nTh < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kde-l10n/kde-l10n-th-4.9.4.tar.xz'
  sha1 '0e7f8779630f174703fe33957f1ffa068f9f2531'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kde-l10n/kde-l10n-th-4.9.95.tar.xz'
    sha1 '3c4ee1e3e75002c150cfb573ca3576c9d7f7a398'
  end

  depends_on 'kdelibs'
end
