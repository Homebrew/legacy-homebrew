require 'formula'

class Plplot < Formula
  homepage 'http://plplot.sourceforge.net'
  url 'https://downloads.sourceforge.net/project/plplot/plplot/5.10.0%20Source/plplot-5.10.0.tar.gz'
  sha1 'ea962cb0138c9b4cbf97ecab1fac1919ea0f939f'

  depends_on 'cmake' => :build
  depends_on 'pkg-config' => :build
  depends_on 'pango'
  depends_on :x11 => :optional

  option 'with-java'

  def install
    args = std_cmake_args
    args << '-DPLD_wxwidgets=OFF' << '-DENABLE_wxwidgets=OFF'
    args << '-DENABLE_java=OFF' if build.without? 'java'
    args << '-DPLD_xcairo=OFF' if build.without? 'x11'
    mkdir "plplot-build" do
      system "cmake", "..", *args
      system "make"
      system "make install"
    end
  end
end
