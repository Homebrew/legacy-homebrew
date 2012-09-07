require 'base_kde_formula'

class KdeBaseapps < BaseKdeFormula
  homepage 'http://kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/kde-baseapps-4.8.1.tar.xz'
  sha1 'bfbc51930a81ea272ddbb1fc9a9cefb9cf9a81d6'
  depends_on 'kdelibs'
  depends_on 'kde-runtime'
end
