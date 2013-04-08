require 'base_kde_formula'

class KdeL10nGl < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-gl-4.10.2.tar.xz'
  sha1 '4c2693f40d43c4110622b003d9658063b61a1760'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-gl-4.10.2.tar.xz'
    sha1 '4c2693f40d43c4110622b003d9658063b61a1760'
  end

  depends_on 'kdelibs'
end
