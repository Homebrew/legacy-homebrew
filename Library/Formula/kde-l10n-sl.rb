require 'base_kde_formula'

class KdeL10nSl < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-sl-4.10.2.tar.xz'
  sha1 '9bd195eca75f2d64ca8dc428e2b51536951681a2'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-sl-4.10.2.tar.xz'
    sha1 '9bd195eca75f2d64ca8dc428e2b51536951681a2'
  end

  depends_on 'kdelibs'
end
