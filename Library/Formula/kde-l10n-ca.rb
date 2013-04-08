require 'base_kde_formula'

class KdeL10nCa < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-ca-4.10.2.tar.xz'
  sha1 '19215a158ec2b98d47d60113d97f66053051ac62'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-ca-4.10.2.tar.xz'
    sha1 '19215a158ec2b98d47d60113d97f66053051ac62'
  end

  depends_on 'kdelibs'
end
