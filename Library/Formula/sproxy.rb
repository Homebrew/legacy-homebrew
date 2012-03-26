require 'formula'

class Sproxy < Formula
  homepage 'http://www.joedog.org/index/sproxy-home'
  url 'http://www.joedog.org/pub/sproxy/sproxy-1.02.tar.gz'
  md5 '458461a1b3f731c77528cc61b547d188'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
    # Makefile doesn't honor mandir, so move manpages post-install
    share.install prefix+'man'
  end
end
