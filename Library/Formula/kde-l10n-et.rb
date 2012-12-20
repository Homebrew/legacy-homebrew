require 'base_kde_formula'

class KdeL10nEt < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kde-l10n/kde-l10n-et-4.9.4.tar.xz'
  sha1 'ef896d66a3ddee05cb555c06fc107c27766e947a'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kde-l10n/kde-l10n-et-4.9.95.tar.xz'
    sha1 '7e21c52653e509821b1566dc18f8edf3257948db'
  end

  depends_on 'kdelibs'
end
