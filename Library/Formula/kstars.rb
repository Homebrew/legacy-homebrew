require 'formula'

class Kstars < Formula
  url 'ftp://ftp.kde.org/pub/kde/stable/4.7.4/src/kstars-4.7.4.tar.bz2'
  homepage 'http://edu.kde.org/kstars/'
  md5 'd1b753e798202d2bf9cac76b552608ac'

  depends_on 'cmake' => :build
  depends_on 'automoc4' => :build
  depends_on 'kdelibs'
  depends_on 'kde-runtime'
  depends_on 'eigen'

  def install
    mkdir 'build'
    cd 'build'
    kdelibs = Formula.factory 'kdelibs'
    system "cmake .. -DCMAKE_INSTALL_PREFIX=#{kdelibs.prefix} -DBUILD_doc=FALSE -DBUNDLE_INSTALL_DIR=#{bin}"
    system "make install"
  end

  def caveats; <<-EOS.undent
    Remember to run brew linkapps.
    EOS
  end

end
