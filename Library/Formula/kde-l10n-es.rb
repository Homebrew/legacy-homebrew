require 'base_kde_formula'

class KdeL10nEs < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-es-4.10.2.tar.xz'
  sha1 'bcf54cec10da8b96a6db5d118215163695a2795b'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-es-4.10.2.tar.xz'
    sha1 'bcf54cec10da8b96a6db5d118215163695a2795b'
  end

  depends_on 'kdelibs'
end
