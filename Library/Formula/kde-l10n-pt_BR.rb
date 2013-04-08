require 'base_kde_formula'

class KdeL10nPtBr < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-pt_BR-4.10.2.tar.xz'
  sha1 '637d34b811bc9be1c2bed0cabdc43263461fea85'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-pt_BR-4.10.2.tar.xz'
    sha1 '637d34b811bc9be1c2bed0cabdc43263461fea85'
  end

  depends_on 'kdelibs'
end
