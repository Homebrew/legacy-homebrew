require 'formula'

class Tcpdump <Formula
  head 'git://github.com/mcr/tcpdump.git'
  homepage 'http://www.tcpdump.org/'

  depends_on 'libpcap'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking","--disable-smb"
    system "make install"
  end
end
