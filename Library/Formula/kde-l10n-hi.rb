require 'base_kde_formula'

class KdeL10nHi < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kde-l10n/kde-l10n-hi-4.9.4.tar.xz'
  sha1 'e37cd49804881f318975028ad3588837fba6de6f'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kde-l10n/kde-l10n-hi-4.9.95.tar.xz'
    sha1 '74f8cdf15201ed7a85518cd4610761c9c77e5964'
  end

  depends_on 'kdelibs'
end
