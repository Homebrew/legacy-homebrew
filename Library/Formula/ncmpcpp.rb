require 'formula'

class Ncmpcpp <Formula
  url 'http://unkart.ovh.org/ncmpcpp/ncmpcpp-0.5.6.tar.bz2'
  homepage 'http://unkart.ovh.org/ncmpcpp/'
  md5 'cdaf82694c0a1f5e9de65bb0a191e403'

  depends_on 'taglib'
  depends_on 'libmpdclient'

  def install
    system "./configure", "--with-taglib", "--with-curl", "--enable-unicode",
                          "--disable-debug", "--disable-dependency-tracking",
                          "LDFLAGS=-liconv", "--prefix=#{prefix}"
    system "make install"
  end
end
