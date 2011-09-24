require 'formula'

class Gperf < Formula
  url 'http://ftpmirror.gnu.org.gnu.org/pub/gnu/gperf/gperf-3.0.4.tar.gz'
  homepage 'http://www.gnu.org/s/gperf/'
  md5 'c1f1db32fb6598d6a93e6e88796a8632'

  # depends_on 'cmake'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    # system "cmake . #{std_cmake_parameters}"
    system "make install"
  end

  def test
    system "gperf"
  end
end
