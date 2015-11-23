class Sntop < Formula
  desc "Curses-based utility that polls hosts to determine connectivity"
  homepage "http://sntop.sourceforge.net/"
  url "http://distcache.freebsd.org/ports-distfiles/sntop-1.4.3.tar.gz"
  sha256 "943a5af1905c3ae7ead064e531cde6e9b3dc82598bbda26ed4a43788d81d6d89"

  depends_on "fping"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--sysconfdir=#{etc}"
    etc.mkpath
    bin.mkpath
    man1.mkpath
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    sntop uses fping by default and fping can only be run by root by default.
    You can run `sudo sntop` (or `sntop -p` which uses standard ping).
    You should be certain that you trust any software you grant root privileges.
    EOS
  end
end
