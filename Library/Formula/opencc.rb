require 'formula'

class Opencc < Formula
  url 'http://opencc.googlecode.com/files/opencc-0.2.0.tar.gz'
  homepage 'http://code.google.com/p/opencc/'
  md5 'fc5915f43f7bd30f0f30ccdc4ad3a7f1'

  depends_on 'cmake'

  def install
    system "cmake . -DCMAKE_INSTALL_PREFIX=#{prefix} -DCMAKE_BUILD_TYPE=Release -DENABLE_GETTEXT:BOOL=OFF"
    system "make"
    system "make install"
  end
end
