require 'base_kde_formula'

class Kde-l10n-tr < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kde-l10n/kde-l10n-tr-4.9.4.tar.xz'
  sha1 'a8e5291a73b6ef638885b45eabe3f17e97f69b6b'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kde-l10n/kde-l10n-tr-4.9.95.tar.xz'
    sha1 'd592ec7ad21d71f85ecbf5a8e22d62c45745fb66'
  end

  depends_on 'kdelibs'
end
