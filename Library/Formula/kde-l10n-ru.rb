require 'base_kde_formula'

class KdeL10nRu < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-ru-4.10.2.tar.xz'
  sha1 '8b6427277ab825aef9aaf144e436e6fdd70202e2'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-ru-4.10.2.tar.xz'
    sha1 '8b6427277ab825aef9aaf144e436e6fdd70202e2'
  end

  depends_on 'kdelibs'
end
