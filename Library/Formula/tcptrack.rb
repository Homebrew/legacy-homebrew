require 'formula'

class Tcptrack < Formula
  homepage 'http://www.rhythm.cx/~steve/devel/tcptrack/'
  url 'http://ftp.de.debian.org/debian/pool/main/t/tcptrack/tcptrack_1.4.2.orig.tar.gz'
  sha1 '921e33279e0032ba3639cdfc674ed74505691d6b'

  def install
    ENV.libstdcxx
    # Fix IPv6 on MacOS. The patch was sent by email to the maintainer
    # (tcptrack2@s.rhythm.cx) on 2010-11-24 for inclusion.
    # Still not fixed in 1.4.2 - @adamv
    inreplace 'src/IPv6Address.cc', 's6_addr16', '__u6_addr.__u6_addr16'

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end

  def caveats
    "Run tcptrack as root or via sudo in order for the program to obtain permissions on the network interface."
  end
end
