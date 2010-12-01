require 'formula'

class Ncmpcpp <Formula
  url 'http://unkart.ovh.org/ncmpcpp/ncmpcpp-0.5.5.tar.bz2'
  homepage 'http://unkart.ovh.org/ncmpcpp/'
  md5 '30cded976c81bba4c8a2daf2215fe41d'

  depends_on 'taglib'
  depends_on 'libmpdclient'

  def install
    args = ["--with-taglib", "--with-curl", "--enable-unicode", "LDFLAGS=-liconv",
            "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"]

    system "./configure", *args
    system "make install"
  end
end
