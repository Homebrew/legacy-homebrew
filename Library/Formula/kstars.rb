require 'base_kde_formula'

class Kstars < BaseKdeFormula
  homepage 'http://edu.kde.org/kstars/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/kstars-4.8.1.tar.xz'
  sha1 '5453568396529c4767fb5485e1493d86bd0e6177'
  depends_on 'kdelibs'
  depends_on 'kde-runtime'
  depends_on 'eigen'
end
