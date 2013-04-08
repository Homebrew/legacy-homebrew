require 'base_kde_formula'

class KdeL10nVi < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-vi-4.10.2.tar.xz'
  sha1 '432acfc264f19e4d6a5f9dff260507e8a2d4ecfb'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-vi-4.10.2.tar.xz'
    sha1 '432acfc264f19e4d6a5f9dff260507e8a2d4ecfb'
  end

  depends_on 'kdelibs'
end
