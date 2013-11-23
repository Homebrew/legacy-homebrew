require 'formula'

class Plplot < Formula
  homepage 'http://plplot.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/plplot/plplot/5.9.10%20Source/plplot-5.9.10.tar.gz'
  sha1 '10dbdfe41d71a9f51e4396729c001ed2baea22fe'

  depends_on 'cmake' => :build
  depends_on 'pkg-config' => :build
  depends_on 'pango'

  option 'with-java'

  def install
    args = std_cmake_args
    args << '-DPLD_wxwidgets=OFF' << '-DENABLE_wxwidgets=OFF'
    args << '-DENABLE_java=OFF' unless build.with? 'java'
    mkdir "plplot-build" do
      system "cmake", "..", *args
      system "make"
      system "make install"
    end
  end
end
