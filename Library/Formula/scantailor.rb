require 'formula'

class Scantailor < Formula
  homepage 'http://scantailor.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/scantailor/scantailor/0.9.11/scantailor-0.9.11.tar.gz'
  sha1 '21ec03317ca2b278179693237eaecd962ee0263b'

  devel do
    url 'http://downloads.sourceforge.net/project/scantailor/scantailor-devel/enhanced/scantailor-enhanced-20120812.tar.bz2'
    version 'enhanced-20120812'
    sha1 'e3535d6e21a1844cf83eb2b23469fb6d90c070a9'
  end

  depends_on 'cmake' => :build
  depends_on 'qt'
  depends_on 'boost'
  depends_on 'jpeg'
  depends_on 'libtiff'
  depends_on :x11

  fails_with :clang do
    build 421
    cause "calling a private constructor of class 'mcalc::Mat<double>'"
  end

  def install
    system "cmake", ".", "-DPNG_INCLUDE_DIR=#{MacOS::X11.include}", *std_cmake_args
    system "make install"
  end
end
