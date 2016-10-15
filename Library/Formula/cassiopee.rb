require 'formula'

class Cassiopee < Formula
  homepage 'http://osallou.github.io/cassiopee-c/'
  url 'https://github.com/osallou/cassiopee-c/archive/1.0.1.tar.gz'
  #version '1.0.1'
  sha1 '53793e14ee1fb8d9d6c9d87be50a7ade8cf58e54'

  depends_on 'cmake' => :build
  depends_on 'boost'
  depends_on 'glog'
  depends_on 'cppunit' => :build
  depends_on 'doxygen' => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make install"
  end

  def test
    system "bin/test_cassiopee"
  end
end
