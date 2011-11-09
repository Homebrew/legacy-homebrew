require 'formula'

class Kate < Formula
  url 'ftp://ftp.kde.org/pub/kde/stable/4.7.3/src/kate-4.7.3.tar.bz2'
  homepage 'http://kate-editor.org'
  md5 'c7bb74c251db064b81b4e0bee4295745'

  depends_on 'cmake' => :build
  depends_on 'automoc4' => :build
  depends_on 'kdelibs'
  depends_on 'kde-runtime'

  def install
    mkdir 'build'
    cd 'build'
    system "cmake .. #{std_cmake_parameters} -DBUILD_doc=FALSE -DBUNDLE_INSTALL_DIR=#{bin}"
    system "make install"
  end

  def caveats; <<-EOS.undent
    Remember to run brew linkapps.
    EOS
  end
end
