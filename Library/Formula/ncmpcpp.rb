require 'formula'

class Ncmpcpp < Formula
  url 'http://unkart.ovh.org/ncmpcpp/ncmpcpp-0.5.8.tar.bz2'
  homepage 'http://unkart.ovh.org/ncmpcpp/'
  md5 '288952c6b4cf4fa3683f3f83a58da37c'

  depends_on 'taglib'
  depends_on 'libmpdclient'

  def install
    system "./configure", "--with-taglib", "--with-curl", "--enable-unicode",
                          "--disable-debug", "--disable-dependency-tracking",
                          "LDFLAGS=-liconv", "--prefix=#{prefix}"
    system "make install"
  end
end
