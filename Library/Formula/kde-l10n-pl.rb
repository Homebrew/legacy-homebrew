require 'base_kde_formula'

class KdeL10nPl < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kde-l10n/kde-l10n-pl-4.9.4.tar.xz'
  sha1 '7997b4b989582713e2f9011ac2a491a6d846f559'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kde-l10n/kde-l10n-pl-4.9.95.tar.xz'
    sha1 '30c1a5399b42986030d7829e760e7bb8cf434c0d'
  end

  depends_on 'kdelibs'
end
