require 'formula'

class Gnugrep < Formula
  url 'http://mirrors.ecvps.com/gnu/grep/grep-2.9.tar.gz'
  homepage 'http://www.gnu.org/s/grep/'
  md5 '03e3451a38b0d615cb113cbeaf252dc0'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "echo grep | #{bin}/grep grep"
  end
end
