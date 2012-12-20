require 'base_kde_formula'

class KdeL10nSk < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kde-l10n/kde-l10n-sk-4.9.4.tar.xz'
  sha1 'd1ebac86d92d19331f10402e0b70366b0b737e2f'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kde-l10n/kde-l10n-sk-4.9.95.tar.xz'
    sha1 '1622c9b8b683280a0de851c6f208969c3b46789a'
  end

  depends_on 'kdelibs'
end
