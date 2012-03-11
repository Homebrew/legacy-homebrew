require 'base_kde_formula'

class Upykde4 < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/pykde4-4.8.1.tar.xz'
  sha1 'b9ef35269d2e08578ba20d01822dbdbed72bffb8'

  depends_on 'kdelibs'
end


