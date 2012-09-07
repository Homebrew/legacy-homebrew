require 'base_kde_formula'

class Kalzium < BaseKdeFormula
  homepage 'http://edu.kde.org/kalzium/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/kalzium-4.8.1.tar.xz'
  sha1 '914072b8a324e6966528e0047ea50c2a52736051'
  depends_on 'kdelibs'
end
