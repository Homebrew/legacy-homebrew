require 'base_kde_formula'

class KdeL10nNds < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kde-l10n/kde-l10n-nds-4.9.4.tar.xz'
  sha1 '0aa75ccd082477539ba47c1e27e602612166f86b'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kde-l10n/kde-l10n-nds-4.9.95.tar.xz'
    sha1 'e8b4ee3535dacf572df253b6436136833e345889'
  end

  depends_on 'kdelibs'
end
