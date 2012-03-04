require 'base_kde_formula'

class Kstars < BaseKdeFormula
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.0/src/kstars-4.8.0.tar.bz2'
  homepage 'http://edu.kde.org/kstars/'
  #md5 'd1b753e798202d2bf9cac76b552608ac'
  depends_on 'kdelibs'
  depends_on 'kde-runtime'
  depends_on 'eigen'
end
