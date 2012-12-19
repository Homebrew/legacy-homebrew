require 'base_kde_formula'

class Kde-l10n-ja < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kde-l10n/kde-l10n-ja-4.9.4.tar.xz'
  sha1 '70006079c40caa6ea6bc1643a30b1fcd1d0a101f'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kde-l10n/kde-l10n-ja-4.9.95.tar.xz'
    sha1 '6bf0b908e48dfb3817b57d727f5ab9bcd6b3f129'
  end

  depends_on 'kdelibs'
end
