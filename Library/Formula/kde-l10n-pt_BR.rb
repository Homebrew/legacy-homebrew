require 'base_kde_formula'

class Kde-l10n-pt_br < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kde-l10n/kde-l10n-pt_BR-4.9.4.tar.xz'
  sha1 'fb926b487ad3c73967225becb48b7bdac6d57c0f'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kde-l10n/kde-l10n-pt_BR-4.9.95.tar.xz'
    sha1 '2c031bdf4882b9a05ae67e1c611c6a99a07b897e'
  end

  depends_on 'kdelibs'
end
