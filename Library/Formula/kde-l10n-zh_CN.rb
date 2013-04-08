require 'base_kde_formula'

class KdeL10nZhCn < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-zh_CN-4.10.2.tar.xz'
  sha1 '77a601392efc52deab08c756c0b8249357d77527'

  devel do
    url 'http://download.kde.org/stable/4.10.2/src/kde-l10n/kde-l10n-zh_CN-4.10.2.tar.xz'
    sha1 '77a601392efc52deab08c756c0b8249357d77527'
  end

  depends_on 'kdelibs'
end
