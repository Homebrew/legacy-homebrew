require 'formula'

class Fakeroot < Formula
  homepage 'http://packages.qa.debian.org/f/fakeroot.html'
  url 'http://ftp.debian.org/debian/pool/main/f/fakeroot/fakeroot_1.18.4.orig.tar.bz2'
  sha1 '60cdd12ea3a72f3676c0f3930ab908ff1f13b996'

  def install
    system "./bootstrap"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--disable-static",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/fakeroot -v"
  end
end
