require 'formula'

class ThcPptpBruter < Formula
  homepage 'http://thc.org'
  url 'http://freeworld.thc.org/releases/thc-pptp-bruter-0.1.4.tar.gz'
  sha1 '88a797ed0dcfb79aba92b319e29d1c5d8c1b14a4'

  def install
    # The function openpty() is defined in pty.h on Linux, but in util.h on OS X.
    # See http://groups.google.com/group/sage-devel/msg/97916255b631e3e5
    inreplace 'src/pptp_bruter.c', 'pty.h', 'util.h'

    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
