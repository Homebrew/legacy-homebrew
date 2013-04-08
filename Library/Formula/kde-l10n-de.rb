require 'base_kde_formula'

class KdeL10nDe < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-de-4.10.2.tar.xz'
  sha1 '4b776eb307c3993352beea784054c96d0ce68d85'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-de-4.10.2.tar.xz'
    sha1 '4b776eb307c3993352beea784054c96d0ce68d85'
  end

  depends_on 'kdelibs'
end
