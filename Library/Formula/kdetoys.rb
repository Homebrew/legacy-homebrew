require 'base_kde_formula'

class Ukdetoys < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/kdetoys-4.8.1.tar.xz'
  sha1 'b0a1c26fa00795767c0d73ff3d25cc339cb005b8'

  depends_on 'kdelibs'
end


