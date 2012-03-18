require 'formula'

class Gperf < Formula
  homepage 'http://www.gnu.org/software/gperf'
  url 'http://ftpmirror.gnu.org/gperf/gperf-3.0.4.tar.gz'
  mirror 'http://ftp.gnu.org/pub/gnu/gperf/gperf-3.0.4.tar.gz'
  md5 'c1f1db32fb6598d6a93e6e88796a8632'

  keg_only "Xcode (up to and including 4.3) provides (a rather old) Gperf."

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/gperf --version"
  end
end
