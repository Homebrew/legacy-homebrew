require 'base_kde_formula'

class KdeL10nRo < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-ro-4.10.2.tar.xz'
  sha1 '5fec50c2675c719f0b814f095ab750301c2d12be'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-ro-4.10.2.tar.xz'
    sha1 '5fec50c2675c719f0b814f095ab750301c2d12be'
  end

  depends_on 'kdelibs'
end
