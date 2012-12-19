require 'base_kde_formula'

class Kde-l10n-zh_cn < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kde-l10n/kde-l10n-zh_CN-4.9.4.tar.xz'
  sha1 '7736ebc6af539801eacd0267a93d2f25873fb53f'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kde-l10n/kde-l10n-zh_CN-4.9.95.tar.xz'
    sha1 '202c9104dff21461dc6280ef303566ec2261a59c'
  end

  depends_on 'kdelibs'
end
