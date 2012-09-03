require 'formula'

class Ngrep < Formula
  url 'http://downloads.sourceforge.net/project/ngrep/ngrep/1.45/ngrep-1.45.tar.bz2'
  homepage 'http://ngrep.sourceforge.net/'
  sha1 'f26090a6ac607db66df99c6fa9aef74968f3330f'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          # this line required to make configure succeed
                          "--with-pcap-includes=/usr/include"
    system "make install"
  end
end
