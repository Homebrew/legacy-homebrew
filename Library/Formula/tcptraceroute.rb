require 'formula'

class Tcptraceroute < Formula
  homepage 'http://michael.toren.net/code/tcptraceroute/'
  url 'https://github.com/mct/tcptraceroute/archive/tcptraceroute-1.5beta7.tar.gz'
  version '1.5beta7'
  sha1 '36b325a73d814cd62932f0def43e7d8e952474c1'

  depends_on 'libnet'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-libnet=#{HOMEBREW_PREFIX}",
                          "--mandir=#{man}"
    system "make install"
  end
end
