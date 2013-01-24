require 'formula'

class Plplot < Formula
  homepage 'http://plplot.sourceforge.net'
  url 'http://sourceforge.net/projects/plplot/files/plplot/5.9.9%20Source/plplot-5.9.9.tar.gz'
  sha1 '3df8fc21723e14af62fea4098e4ef019e1b52a54'

  depends_on 'cmake' => :build
  depends_on 'pkg-config' => :build
  depends_on 'pango'

  def install
    mkdir "plplot-build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make install"
    end
  end
end
