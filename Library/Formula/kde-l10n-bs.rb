require 'base_kde_formula'

class KdeL10nBs < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kde-l10n/kde-l10n-bs-4.9.4.tar.xz'
  sha1 '12c15627583e12f88e01acb76ca907a369aa5252'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kde-l10n/kde-l10n-bs-4.9.95.tar.xz'
    sha1 '3dbaa0e8257960da0f9ee22552c6fe811a659e9d'
  end

  depends_on 'kdelibs'
end
