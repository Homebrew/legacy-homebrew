require 'base_kde_formula'

class KdeL10nSi < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-si-4.10.2.tar.xz'
  sha1 '8c6258ec1fb86a68705631e3f3edc8ed8a0feee8'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-si-4.10.2.tar.xz'
    sha1 '8c6258ec1fb86a68705631e3f3edc8ed8a0feee8'
  end

  depends_on 'kdelibs'
end
