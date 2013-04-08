require 'base_kde_formula'

class KdeL10nIt < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-it-4.10.2.tar.xz'
  sha1 '46b91e83098edccafafad28d1c3d63ce0e642f03'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-it-4.10.2.tar.xz'
    sha1 '46b91e83098edccafafad28d1c3d63ce0e642f03'
  end

  depends_on 'kdelibs'
end
