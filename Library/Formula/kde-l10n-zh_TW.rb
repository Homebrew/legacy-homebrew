require 'base_kde_formula'

class KdeL10nZhTw < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kde-l10n/kde-l10n-zh_TW-4.9.4.tar.xz'
  sha1 '71d51608b048232eef836765515087a55b153c0c'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kde-l10n/kde-l10n-zh_TW-4.9.95.tar.xz'
    sha1 'e1225b1a9569298c89d67ab57154e5648ac843a7'
  end

  depends_on 'kdelibs'
end
