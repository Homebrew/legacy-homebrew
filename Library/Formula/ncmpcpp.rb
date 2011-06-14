require 'formula'

class Ncmpcpp < Formula
  url 'http://unkart.ovh.org/ncmpcpp/ncmpcpp-0.5.7.tar.bz2'
  homepage 'http://unkart.ovh.org/ncmpcpp/'
  md5 '6632c76f2f0836c5aa5a1a2fbb1c921c'

  depends_on 'taglib'
  depends_on 'libmpdclient'

  def install
    system "./configure", "--with-taglib", "--with-curl", "--enable-unicode",
                          "--disable-debug", "--disable-dependency-tracking",
                          "LDFLAGS=-liconv", "--prefix=#{prefix}"
    system "make install"
  end
end
