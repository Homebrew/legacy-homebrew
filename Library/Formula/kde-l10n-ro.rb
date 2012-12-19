require 'base_kde_formula'

class Kde-l10n-ro < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kde-l10n/kde-l10n-ro-4.9.4.tar.xz'
  sha1 '14794d5e9ae305ac9a974b518bb8f350f963a6ef'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kde-l10n/kde-l10n-ro-4.9.95.tar.xz'
    sha1 '96e5c3a2fcf3624f322aca63d1cb6cb3615e9943'
  end

  depends_on 'kdelibs'
end
