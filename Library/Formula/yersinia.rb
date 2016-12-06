require 'formula'

class Yersinia < Formula
  homepage 'http://www.yersinia.net'
  url 'http://www.yersinia.net/download/yersinia-0.7.tar.gz'
  version '0.7'
  sha1 'ea8531d7d1fae119324e257cf33f137da8188811'

  depends_on 'libnet'
  depends_on 'libpcap'  

  def install
    system "./configure", "--with-libnet-includes=/usr/local/include/", 
			  "--disable-gtk", 
			  "--with-pcap-includes=/usr/local/include",
                          "--prefix=#{prefix}"
    system "make"
    system "make install" # if this fails, try separate make/make install steps
  end
end
