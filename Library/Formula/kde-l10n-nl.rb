require 'base_kde_formula'

class Kde-l10n-nl < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kde-l10n/kde-l10n-nl-4.9.4.tar.xz'
  sha1 '975139d14d8d95d6e0ed5872a7bc7308262c77ef'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kde-l10n/kde-l10n-nl-4.9.95.tar.xz'
    sha1 '8001ce104b3ce6ff3ba2bae70c0099262f1f7490'
  end

  depends_on 'kdelibs'
end
