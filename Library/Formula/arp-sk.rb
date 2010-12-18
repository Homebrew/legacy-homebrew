require 'formula'

class ArpSk <Formula
  url 'http://sid.rstack.org/arp-sk/files/arp-sk-0.0.16.tgz'
  homepage 'http://sid.rstack.org/arp-sk/'
  md5 '25198bc6f8e0ac5ee9d3bb1b8be5adc5'

  depends_on 'libnet'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-libnet=#{HOMEBREW_PREFIX}"
    system "make install"
  end
end
