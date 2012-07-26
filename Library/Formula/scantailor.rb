require 'formula'

class Scantailor < Formula
  homepage 'http://scantailor.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/scantailor/scantailor/0.9.11/scantailor-0.9.11.tar.gz'
  md5 '15984c8828ecb2de542ac94e3c41a810'

  devel do
    url 'http://downloads.sourceforge.net/project/scantailor/scantailor-devel/enhanced/scantailor-enhanced-20111213.tar.gz'
    version 'enhanced-20111213'
    md5 'bcba593dcba17880429884fe2bfb1d2a'
  end

  depends_on 'cmake' => :build
  depends_on 'qt'
  depends_on 'boost'
  depends_on 'jpeg'
  depends_on 'libtiff'
  depends_on :x11

  fails_with :clang do
    build 318
    cause "calling a private constructor of class 'mcalc::Mat<double>'"
  end

  def install
    system "cmake", ".", "-DPNG_INCLUDE_DIR=#{MacOS::XQuartz.include}", *std_cmake_args
    system "make install"
  end
end
