require 'base_kde_formula'

class KdeL10nDe < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kde-l10n/kde-l10n-de-4.9.4.tar.xz'
  sha1 'b84fb87f795a91df7b8f84ce338abf2fba6faebe'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kde-l10n/kde-l10n-de-4.9.95.tar.xz'
    sha1 '2ef9744d64130f86cddcc92e45c1fcc83bce53af'
  end

  depends_on 'kdelibs'
end
