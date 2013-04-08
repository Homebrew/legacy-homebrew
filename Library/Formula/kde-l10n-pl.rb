require 'base_kde_formula'

class KdeL10nPl < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-pl-4.10.2.tar.xz'
  sha1 '9c80fe230ce714d2961049236b25eb2c3ff9e7a5'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-pl-4.10.2.tar.xz'
    sha1 '9c80fe230ce714d2961049236b25eb2c3ff9e7a5'
  end

  depends_on 'kdelibs'
end
