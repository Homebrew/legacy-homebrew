require 'base_kde_formula'

class Uanalitza < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/analitza-4.8.1.tar.xz'
  sha1 '94c175417126c578c38f29c348a8bb8f54cdfb45'

  depends_on 'kdelibs'
end


