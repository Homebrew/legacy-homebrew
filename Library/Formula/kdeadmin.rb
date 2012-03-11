require 'base_kde_formula'

class Ukdeadmin < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/kdeadmin-4.8.1.tar.xz'
  sha1 '0ee44575bfb45159ced6d4d046b07323ebab00e7'

  depends_on 'kdelibs'
end


