require 'base_kde_formula'

class KdeL10nCaValencia < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kde-l10n/kde-l10n-ca@valencia-4.9.4.tar.xz'
  sha1 '71a6fe1bf9d938edbd4c8c27eb1cc6abf61ff9be'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kde-l10n/kde-l10n-ca@valencia-4.9.95.tar.xz'
    sha1 '10deb579cb1b36c166b2e50e5d3bcaf80fbedc39'
  end

  depends_on 'kdelibs'
end
