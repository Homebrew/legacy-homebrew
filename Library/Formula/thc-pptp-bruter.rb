require 'formula'

class ThcPptpBruter < Formula
  url 'http://freeworld.thc.org/releases/thc-pptp-bruter-0.1.4.tar.gz'
  homepage 'http://thc.org'
  md5 'a48160ad94169b6c7b12d561c2e5724e'

  def install
    # The function openpty() is defined in pty.h on Linux, but in util.h on OS X.
    # See http://groups.google.com/group/sage-devel/msg/97916255b631e3e5
    inreplace 'src/pptp_bruter.c', 'pty.h', 'util.h'

    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
