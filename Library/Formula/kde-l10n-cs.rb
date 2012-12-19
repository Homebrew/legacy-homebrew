require 'base_kde_formula'

class Kde-l10n-cs < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kde-l10n/kde-l10n-cs-4.9.4.tar.xz'
  sha1 'f9545b3178ec77c73772b93568122da50086d801'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kde-l10n/kde-l10n-cs-4.9.95.tar.xz'
    sha1 '0350e8399f30e2aabffdc07f3a906da1f593da5b'
  end

  depends_on 'kdelibs'
end
