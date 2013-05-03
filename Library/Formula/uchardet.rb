require 'formula'

class Uchardet < Formula
  homepage 'http://code.google.com/p/uchardet/'
  url 'http://uchardet.googlecode.com/files/uchardet-0.0.1.tar.gz'
  sha1 'c81264cca67f3e7c46e284288f8cab7a34b3f386'

  depends_on 'cmake' => :build

  def install
    args = std_cmake_args
    args << "-DCMAKE_INSTALL_NAME_DIR=#{lib}"
    system "cmake", '.', *args
    system "make install"
  end

  def test
    system "#{bin}/uchardet", __FILE__
  end
end
