require 'formula'

class Konsole < Formula
  url 'ftp://ftp.kde.org/pub/kde/stable/4.7.4/src/konsole-4.7.4.tar.bz2'
  homepage 'http://konsole.kde.org/'
  md5 'c3828a382cb83b8d3c4e1ffcedb16172'

  depends_on 'cmake' => :build
  depends_on 'automoc4' => :build
  depends_on 'kdelibs'
  depends_on 'kde-runtime'

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
