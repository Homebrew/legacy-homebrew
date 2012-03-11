require 'base_kde_formula'

class Urocs < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/rocs-4.8.1.tar.xz'
  sha1 'b485fe77d48bb82d3b2e6d79337ba4898c06ae5d'

  depends_on 'kdelibs'
end


