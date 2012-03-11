require 'base_kde_formula'

class Uark < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/ark-4.8.1.tar.xz'
  sha1 '57f032d3d3333ca6cede1f214e6d8e178bbe7cf7'

  depends_on 'kdelibs'
end


