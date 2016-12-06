require 'formula'

class Plplot < Formula
  url 'http://sourceforge.net/projects/plplot/files/plplot/5.9.9%20Source/plplot-5.9.9.tar.gz'
  homepage 'http://plplot.sourceforge.net'
  sha1 '3df8fc21723e14af62fea4098e4ef019e1b52a54'

  depends_on 'cmake' => :build
  depends_on 'pkg-config' => :build
  depends_on 'pango'

  def install
    system "mkdir plplot-build"
    Dir.chdir "plplot-build"
    system "cmake #{std_cmake_parameters} .."
    system "make"
    system "make install"
  end
end
