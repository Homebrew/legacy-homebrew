require 'base_kde_formula'

class KdeL10nEl < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kde-l10n/kde-l10n-el-4.9.4.tar.xz'
  sha1 '050c95540cb39313016265dc6d523a21fa00d082'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kde-l10n/kde-l10n-el-4.9.95.tar.xz'
    sha1 'ef1a408ba5ce20b6d651f5e68e82950422fc3f65'
  end

  depends_on 'kdelibs'
end
