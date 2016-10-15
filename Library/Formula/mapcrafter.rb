require 'formula'

class Mapcrafter < Formula
  homepage 'http://mapcrafter.org'
  url 'https://github.com/m0r13/mapcrafter/archive/v.1.1.zip'
  sha1 '125e5559e713a5d7be3c94c575edf8a795043f7f'

  depends_on 'cmake' => :build
  depends_on 'libpng'
  depends_on 'boost'


  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
   system "make", "runtests"
  end
end
