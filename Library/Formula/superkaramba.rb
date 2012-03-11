require 'base_kde_formula'

class Usuperkaramba < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/superkaramba-4.8.1.tar.xz'
  sha1 '934a62e3d82e92a99b9d070a2dd39634b7351cea'

  depends_on 'kdelibs'
end


