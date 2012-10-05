require 'formula'

class Libevhtp < Formula
  homepage 'http://github.com/ellzey/libevhtp'
  url 'https://github.com/ellzey/libevhtp/tarball/1.1.4'
  version '1.1.4'
  sha1 'd221d1fdbf68e44d1e19546cc025014b5d120f85'

  head 'git://github.com/ellzey/libevhtp.git'

  depends_on 'cmake' => :build
  depends_on 'libevent'

  def install
    system "cmake", ".", *std_cmake_args
    system "make install" # if this fails, try separate make/make install steps
  end
end
