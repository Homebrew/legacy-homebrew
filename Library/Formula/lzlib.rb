require 'formula'

class Lzlib < Formula
  homepage 'http://www.nongnu.org/lzip/lzlib.html'
  url 'http://download.savannah.gnu.org/releases/lzip/lzlib-1.5.tar.gz'
  sha1 'b89060b72c8357e0d0ca5198d48e97b5650a6d2c'

  bottle do
    cellar :any
    sha1 "31e2cdf3e199f746189eefcd0a5c0fa4bc69caba" => :mavericks
    sha1 "ca854e06e248bf072272ffd723484c4254e0bc89" => :mountain_lion
    sha1 "4b2b4abb16165cb0931b3ed197851410a2c46684" => :lion
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "CC=#{ENV.cc}",
                          "CFLAGS=#{ENV.cflags}"
    system "make"
    system "make check"
    system "make install"
  end
end
