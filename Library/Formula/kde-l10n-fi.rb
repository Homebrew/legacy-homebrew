require 'base_kde_formula'

class Kde-l10n-fi < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kde-l10n/kde-l10n-fi-4.9.4.tar.xz'
  sha1 'd7fe13f87288ec075bda0ff48ea54c10dda4772e'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kde-l10n/kde-l10n-fi-4.9.95.tar.xz'
    sha1 '4a6dd520af20a8f82d138b84b642c1c08456d922'
  end

  depends_on 'kdelibs'
end
