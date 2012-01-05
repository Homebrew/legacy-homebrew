require 'formula'

class Kolourpaint < Formula
  url 'http://download.kde.org/stable/4.7.4/src/kolourpaint-4.7.4.tar.bz2'
  homepage 'http://www.kolourpaint.org/'
  md5 'fff4e25a8f5158944997b81552dac776'

  depends_on 'cmake' => :build
  depends_on 'automoc4' => :build
  depends_on 'kdelibs'
  depends_on 'kde-runtime'

  def install
    #ENV.x11
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
