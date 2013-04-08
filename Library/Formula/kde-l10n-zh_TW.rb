require 'base_kde_formula'

class KdeL10nZhTw < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-zh_TW-4.10.2.tar.xz'
  sha1 '2247859f09e3f0b1a99961c5fcdf0fcb4afc84a2'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-zh_TW-4.10.2.tar.xz'
    sha1 '2247859f09e3f0b1a99961c5fcdf0fcb4afc84a2'
  end

  depends_on 'kdelibs'
end
