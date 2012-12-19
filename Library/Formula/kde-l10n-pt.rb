require 'base_kde_formula'

class Kde-l10n-pt < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kde-l10n/kde-l10n-pt-4.9.4.tar.xz'
  sha1 '176b9217c1350d0a6d93a972f230f896cda7367e'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kde-l10n/kde-l10n-pt-4.9.95.tar.xz'
    sha1 'eaaa4bb50f390ca3251606dd797da8fe3bf6032d'
  end

  depends_on 'kdelibs'
end
