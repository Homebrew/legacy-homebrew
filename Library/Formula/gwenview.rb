require 'base_kde_formula'

class Ugwenview < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/gwenview-4.8.1.tar.xz'
  sha1 'c549b0256140c6c466e3279cf12bdc6e6ee82960'

  depends_on 'kdelibs'
end


