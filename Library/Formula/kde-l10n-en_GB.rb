require 'base_kde_formula'

class KdeL10nEnGb < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kde-l10n/kde-l10n-en_GB-4.9.4.tar.xz'
  sha1 '4c30307da390c2b93faeab4defb88f1027643b47'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kde-l10n/kde-l10n-en_GB-4.9.95.tar.xz'
    sha1 '99748722011c5b5854ba3c59054a4ac32c90283c'
  end

  depends_on 'kdelibs'
end
