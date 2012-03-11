require 'base_kde_formula'

class Ukdeartwork < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/kdeartwork-4.8.1.tar.xz'
  sha1 '31215ff41d01c8bf680578abe57b65648441a135'

  depends_on 'kdelibs'
end


