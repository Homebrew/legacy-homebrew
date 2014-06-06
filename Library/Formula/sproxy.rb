require 'formula'

class Sproxy < Formula
  homepage 'http://www.joedog.org/index/sproxy-home'
  url 'http://www.joedog.org/pub/sproxy/sproxy-1.02.tar.gz'
  sha1 'afda6727f7a65445556cd849161c0c752c47a7f6'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
    # Makefile doesn't honor mandir, so move manpages post-install
    share.install prefix+'man'
  end
end
