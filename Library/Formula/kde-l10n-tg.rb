require 'base_kde_formula'

class KdeL10nTg < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-tg-4.10.2.tar.xz'
  sha1 'd84e3c15d76a0593a6d8890edc37ad347bac7cf4'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-tg-4.10.2.tar.xz'
    sha1 'd84e3c15d76a0593a6d8890edc37ad347bac7cf4'
  end

  depends_on 'kdelibs'
end
