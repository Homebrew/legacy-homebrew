require 'formula'

class Mapcrafter < Formula
  homepage 'http://mapcrafter.org'
  url 'https://github.com/m0r13/mapcrafter/archive/v.1.1.2.zip'
  sha1 'd303cf08504fa65c86032cb50fd852f65e92d629'

  depends_on 'cmake' => :build
  depends_on 'libpng'
  depends_on 'boost'


  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    system "make", "runtests"
  end

  test do
   system "mapcrafter", "--version"
  end
end
