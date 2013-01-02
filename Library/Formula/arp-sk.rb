require 'formula'

class ArpSk < Formula
  url 'http://sid.rstack.org/arp-sk/files/arp-sk-0.0.16.tgz'
  homepage 'http://sid.rstack.org/arp-sk/'
  sha1 'c7c0af367640d852f3ff622c5b03096ce4e940a4'

  depends_on 'libnet'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-libnet=#{HOMEBREW_PREFIX}"
    system "make install"
  end
end
