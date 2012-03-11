require 'base_kde_formula'

class Ukwordquiz < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/kwordquiz-4.8.1.tar.xz'
  sha1 '954e49b9dea8e486f8316b9215e12d736e9b1448'

  depends_on 'kdelibs'
end


