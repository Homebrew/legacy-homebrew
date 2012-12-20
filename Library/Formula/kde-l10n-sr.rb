require 'base_kde_formula'

class KdeL10nSr < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kde-l10n/kde-l10n-sr-4.9.4.tar.xz'
  sha1 'fb06f22c0c87a82a25dd419917046088a994262f'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kde-l10n/kde-l10n-sr-4.9.95.tar.xz'
    sha1 'c58fcb9fe8d7519e593bdf650399b4f1ba494294'
  end

  depends_on 'kdelibs'
end
