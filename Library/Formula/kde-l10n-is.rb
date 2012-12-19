require 'base_kde_formula'

class Kde-l10n-is < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kde-l10n/kde-l10n-is-4.9.4.tar.xz'
  sha1 '9511b678a25a0abe1bfbdd845af85bac3aa50f51'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kde-l10n/kde-l10n-is-4.9.95.tar.xz'
    sha1 'ebbb47394d39d10cf5ec85a6fd2d7b60a1c1e66f'
  end

  depends_on 'kdelibs'
end
