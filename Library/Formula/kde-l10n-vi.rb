require 'base_kde_formula'

class KdeL10nVi < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kde-l10n/kde-l10n-vi-4.9.4.tar.xz'
  sha1 'f08b14fc57c40094211aa1ed44912b68fd22cf9a'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kde-l10n/kde-l10n-vi-4.9.95.tar.xz'
    sha1 'b8b203d34b7b6258c9d2ec69d4c41651393740f6'
  end

  depends_on 'kdelibs'
end
