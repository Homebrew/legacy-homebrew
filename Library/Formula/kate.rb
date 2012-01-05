require 'formula'

class Kate < Formula
  url 'ftp://ftp.kde.org/pub/kde/stable/4.7.4/src/kate-4.7.4.tar.bz2'
  homepage 'http://kate-editor.org'
  md5 '565ebff0d1e2316097897149eeb4d255'

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
