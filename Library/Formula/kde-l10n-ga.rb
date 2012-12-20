require 'base_kde_formula'

class KdeL10nGa < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kde-l10n/kde-l10n-ga-4.9.4.tar.xz'
  sha1 'be02925113c5b1f84558972697f064a57bbd2e0e'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kde-l10n/kde-l10n-ga-4.9.95.tar.xz'
    sha1 'fdee88acce3f7c3e8e29d65e09542b836db11dc1'
  end

  depends_on 'kdelibs'
end
