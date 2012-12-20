require 'base_kde_formula'

class KdeL10nHu < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kde-l10n/kde-l10n-hu-4.9.4.tar.xz'
  sha1 '1cc483c937a841cfce95b8251de6449065d99e1c'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kde-l10n/kde-l10n-hu-4.9.95.tar.xz'
    sha1 'a133fdbd5f3516bc5adb3e86d65b6936281abae0'
  end

  depends_on 'kdelibs'
end
