require 'base_kde_formula'

class Ukimono < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/kimono-4.8.1.tar.xz'
  sha1 'cecf979d52091a2baaabb7334750f8376d835b0a'

  depends_on 'kdelibs'
end


