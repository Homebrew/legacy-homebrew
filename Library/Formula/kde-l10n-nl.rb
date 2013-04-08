require 'base_kde_formula'

class KdeL10nNl < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-nl-4.10.2.tar.xz'
  sha1 '6f9471bacce740b7216ccb35f4d7f3c14c42bef9'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-nl-4.10.2.tar.xz'
    sha1 '6f9471bacce740b7216ccb35f4d7f3c14c42bef9'
  end

  depends_on 'kdelibs'
end
