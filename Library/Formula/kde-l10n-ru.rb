require 'base_kde_formula'

class KdeL10nRu < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kde-l10n/kde-l10n-ru-4.9.4.tar.xz'
  sha1 'd7b7d7721743966ea5e406a6a44298ad3a1d6a95'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kde-l10n/kde-l10n-ru-4.9.95.tar.xz'
    sha1 '170d61f8795dbe762b404686c59a1c1e17c6246b'
  end

  depends_on 'kdelibs'
end
