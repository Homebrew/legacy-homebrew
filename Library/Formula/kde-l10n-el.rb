require 'base_kde_formula'

class KdeL10nEl < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-el-4.10.2.tar.xz'
  sha1 'cd91e9caa76634a7e57178269b7cda92dd746cc7'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-el-4.10.2.tar.xz'
    sha1 'cd91e9caa76634a7e57178269b7cda92dd746cc7'
  end

  depends_on 'kdelibs'
end
