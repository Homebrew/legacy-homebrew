class LibxmpLite < Formula
  homepage "http://xmp.sourceforge.net"
  url "https://downloads.sourceforge.net/project/xmp/libxmp/4.3.5/libxmp-lite-4.3.5.tar.gz"
  sha1 "45ae99bf939f1fe2cb8c75ec76406cbb028a1bf8"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
