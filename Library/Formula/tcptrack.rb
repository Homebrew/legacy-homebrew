require 'formula'

class Tcptrack < Formula
  url 'http://www.rhythm.cx/~steve/devel/tcptrack/release/1.4.0/source/tcptrack-1.4.0.tar.gz'
  homepage 'http://www.rhythm.cx/~steve/devel/tcptrack/'
  md5 'c177a4f170eefb2c3719965694496228'

  def install
    # Fix IPv6 on MacOS. The patch was sent by email to the maintainer
    # (tcptrack2@s.rhythm.cx) on 2010-11-24 for inclusion.
    inreplace 'src/IPv6Address.cc', 's6_addr16', '__u6_addr.__u6_addr16'

    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end

  def caveats
    "Run tcptrack as root or via sudo in order for the program to obtain permissions on the network interface."
  end
end
