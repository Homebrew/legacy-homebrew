require 'base_kde_formula'

class KdeL10nEnGb < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-en_GB-4.10.2.tar.xz'
  sha1 '00cfe50d5ce60ae2ac17a5bf58aee61a83dbb039'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-en_GB-4.10.2.tar.xz'
    sha1 '00cfe50d5ce60ae2ac17a5bf58aee61a83dbb039'
  end

  depends_on 'kdelibs'
end
