require 'base_kde_formula'

class KdeL10nCaValencia < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-ca@valencia-4.10.2.tar.xz'
  sha1 '3e2b1a20b0d608b99461ec0ffde6ff3b1d043444'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-ca@valencia-4.10.2.tar.xz'
    sha1 '3e2b1a20b0d608b99461ec0ffde6ff3b1d043444'
  end

  depends_on 'kdelibs'
end
