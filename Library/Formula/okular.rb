require 'base_kde_formula'

class Uokular < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/okular-4.8.1.tar.xz'
  sha1 'ddf676820acf3615d1996bf40e82ebd5c9aa41d8'

  depends_on 'kdelibs'
end


