require 'formula'

class Tcptraceroute <Formula
  url 'http://michael.toren.net/code/tcptraceroute/tcptraceroute-1.5beta7.tar.gz'
  homepage 'http://michael.toren.net/code/tcptraceroute/'
  version '1.5beta7'
  md5 '65d1001509f971ea986fcbc2dd009643'

  depends_on 'libnet'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-libnet=#{HOMEBREW_PREFIX}",
                          "--mandir=#{man}"
    system "make install"
  end
end
