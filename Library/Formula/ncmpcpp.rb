require 'formula'

class Ncmpcpp <Formula
  url 'http://unkart.ovh.org/ncmpcpp/ncmpcpp-0.5.5.tar.bz2'
  homepage 'http://unkart.ovh.org/ncmpcpp/'
  md5 '30cded976c81bba4c8a2daf2215fe41d'

  depends_on 'taglib'
  depends_on 'libmpdclient'

  def install
    system "./configure", "--with-taglib", "--with-curl", "--enable-unicode",
                          "--disable-debug", "--disable-dependency-tracking",
                          "LDFLAGS=-liconv", "--prefix=#{prefix}"
    system "make install"
  end
end
