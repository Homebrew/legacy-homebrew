require 'base_kde_formula'

class KdeL10nMr < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-mr-4.10.2.tar.xz'
  sha1 '3ab5e85d20722fc26a18e7e1410866e7accfb5d1'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-mr-4.10.2.tar.xz'
    sha1 '3ab5e85d20722fc26a18e7e1410866e7accfb5d1'
  end

  depends_on 'kdelibs'
end
