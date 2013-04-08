require 'base_kde_formula'

class KdeL10nGa < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-ga-4.10.2.tar.xz'
  sha1 'f843d307eb5d12aab783e620d67ab4870e5582ff'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-ga-4.10.2.tar.xz'
    sha1 'f843d307eb5d12aab783e620d67ab4870e5582ff'
  end

  depends_on 'kdelibs'
end
