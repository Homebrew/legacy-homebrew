require 'base_kde_formula'

class KdeL10nUk < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-uk-4.10.2.tar.xz'
  sha1 '2e6153b1390e979c4ad6ebb88e589d7cc922e7d5'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-uk-4.10.2.tar.xz'
    sha1 '2e6153b1390e979c4ad6ebb88e589d7cc922e7d5'
  end

  depends_on 'kdelibs'
end
