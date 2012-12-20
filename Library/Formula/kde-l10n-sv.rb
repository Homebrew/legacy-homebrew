require 'base_kde_formula'

class KdeL10nSv < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kde-l10n/kde-l10n-sv-4.9.4.tar.xz'
  sha1 '0888ddce4febd0af32dfb1a2115825761f1afce1'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kde-l10n/kde-l10n-sv-4.9.95.tar.xz'
    sha1 '0bd0ab3149f11cae7f8032eb6820f7ce50e9db0d'
  end

  depends_on 'kdelibs'
end
