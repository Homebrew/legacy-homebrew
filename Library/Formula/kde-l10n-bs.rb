require 'base_kde_formula'

class KdeL10nBs < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-bs-4.10.2.tar.xz'
  sha1 '572f0b347577ed702d4fc4acc2eaac9b19e7b3d9'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-bs-4.10.2.tar.xz'
    sha1 '572f0b347577ed702d4fc4acc2eaac9b19e7b3d9'
  end

  depends_on 'kdelibs'
end
