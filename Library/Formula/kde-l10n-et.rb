require 'base_kde_formula'

class KdeL10nEt < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-et-4.10.2.tar.xz'
  sha1 '75b763cf2d3803bf0c0a9cdfb19b825f05027705'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-et-4.10.2.tar.xz'
    sha1 '75b763cf2d3803bf0c0a9cdfb19b825f05027705'
  end

  depends_on 'kdelibs'
end
