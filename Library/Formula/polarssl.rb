require 'formula'

class Polarssl < Formula
  homepage 'http://polarssl.org/'
  url 'https://polarssl.org/download/polarssl-1.3.3-gpl.tgz'
  sha1 'c1072e97b21e94721b8d37509a589ea10249fdbd'

  depends_on 'cmake' => :build

  conflicts_with 'md5sha1sum', :because => 'both install conflicting binaries'

  def install
    system "cmake", ".",  *std_cmake_args
    system "make"
    system "make install"
  end
end
