require 'base_kde_formula'

class Ukcolorchooser < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/kcolorchooser-4.8.1.tar.xz'
  sha1 'b82a86ac95ca9b4c1dbd66b8164ce855232fec69'

  depends_on 'kdelibs'
end


