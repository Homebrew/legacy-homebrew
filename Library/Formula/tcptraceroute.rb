require 'formula'

class Tcptraceroute < Formula
  homepage 'http://michael.toren.net/code/tcptraceroute/'
  url 'http://michael.toren.net/code/tcptraceroute/tcptraceroute-1.5beta7.tar.gz'
  version '1.5beta7'
  sha1 '78847ef4ba7031cee660c540593256fd384a1a62'

  depends_on 'libnet'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-libnet=#{HOMEBREW_PREFIX}",
                          "--mandir=#{man}"
    system "make install"
  end
end
