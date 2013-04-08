require 'base_kde_formula'

class KdeL10nNds < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-nds-4.10.2.tar.xz'
  sha1 '9f28f88ca10d7cf9598aea4d27196744d7a7e8ae'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-nds-4.10.2.tar.xz'
    sha1 '9f28f88ca10d7cf9598aea4d27196744d7a7e8ae'
  end

  depends_on 'kdelibs'
end
