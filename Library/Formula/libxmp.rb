require "formula"

class Libxmp < Formula
  homepage "http://xmp.sourceforge.net"
  url "https://downloads.sourceforge.net/project/xmp/libxmp/4.3.1/libxmp-4.3.1.tar.gz"
  sha1 "feb07a6fd460be8086a451931aa8507fe8953382"

  bottle do
    cellar :any
    sha1 "868e25bcb0e649aa75ef444e4a1386f2c956002c" => :yosemite
    sha1 "e7ba97dd07f2935db97a991a96af828ef5d1cb77" => :mavericks
    sha1 "b30afb2e4703afe6b2685d037effd4c1c793caf1" => :mountain_lion
  end

  head do
    url "git://git.code.sf.net/p/xmp/libxmp"
    depends_on "autoconf" => :build
  end

  def install
    system "autoconf" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
