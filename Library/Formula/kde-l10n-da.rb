require 'base_kde_formula'

class Kde-l10n-da < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kde-l10n/kde-l10n-da-4.9.4.tar.xz'
  sha1 '7b3eacdcb5a0fd20ebbfb0382a82b8ba05ede129'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kde-l10n/kde-l10n-da-4.9.95.tar.xz'
    sha1 'bbe931166754463c676e94ff393557023d98a1d7'
  end

  depends_on 'kdelibs'
end
