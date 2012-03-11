require 'base_kde_formula'

class Usvgpart < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/svgpart-4.8.1.tar.xz'
  sha1 '2332156b52c9f1a33cc0f0cb9d64f01aaf38f9bc'

  depends_on 'kdelibs'
end


