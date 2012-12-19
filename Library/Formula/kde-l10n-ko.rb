require 'base_kde_formula'

class Kde-l10n-ko < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'http://download.kde.org/stable/4.9.4/src/kde-l10n/kde-l10n-ko-4.9.4.tar.xz'
  sha1 'dbb114867809ef44e34fe566a4292430e663bc49'

  devel do
    url 'http://download.kde.org/unstable/4.9.95/src/kde-l10n/kde-l10n-ko-4.9.95.tar.xz'
    sha1 '317012d554d050ca79232363158343f90672222b'
  end

  depends_on 'kdelibs'
end
