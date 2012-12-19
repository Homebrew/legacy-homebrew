require 'base_kde_formula'

class Kde-l10n-ca < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kde-l10n/kde-l10n-ca-4.9.4.tar.xz'
  sha1 '670fea59b84ff490fde38573cd7e02c90ce90698'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kde-l10n/kde-l10n-ca-4.9.95.tar.xz'
    sha1 '03d280531b31649ba05b4c397a7daf27ca04cd4a'
  end

  depends_on 'kdelibs'
end
