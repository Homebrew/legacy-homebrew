require 'base_kde_formula'

class Kde-l10n-it < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kde-l10n/kde-l10n-it-4.9.4.tar.xz'
  sha1 '94ca9e9ea815c01192e23a804aa484dd8917ed5e'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kde-l10n/kde-l10n-it-4.9.95.tar.xz'
    sha1 'c2193b6d4235307d94e2f73fe9c1c7f6dcf2de95'
  end

  depends_on 'kdelibs'
end
