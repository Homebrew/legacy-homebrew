require "formula"

class Bsdmainutils < Formula
  homepage "https://packages.debian.org/sid/bsdmainutils"
  url "http://ftp.debian.org/debian/pool/main/b/bsdmainutils/bsdmainutils_9.0.6.tar.gz"
  sha1 "26a24856e8e026eeca8978a8b5074c83c7fd0db2"

  def install
    system "for i in `<debian/patches/series`; do patch -p1 <debian/patches/$i; done"
    inreplace "Makefile", "/usr/", "#{prefix}/"
    inreplace "config.mk", "/usr/", "#{prefix}/"
    inreplace "config.mk", " -o root -g root", ""
    inreplace "usr.bin/write/Makefile", "chown root:tty $(bindir)/$(PROG)", ""
    system "make", "install"
  end

  test do
    system "#{bin}/cal"
  end
end
