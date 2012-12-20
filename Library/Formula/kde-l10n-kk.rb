require 'base_kde_formula'

class KdeL10nKk < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kde-l10n/kde-l10n-kk-4.9.4.tar.xz'
  sha1 'ff20f459d3ed3839fc539b38f95ce18480fd130c'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kde-l10n/kde-l10n-kk-4.9.95.tar.xz'
    sha1 '26dafe1c44a805f8a74502c8236f7b860e8e5a13'
  end

  depends_on 'kdelibs'
end
