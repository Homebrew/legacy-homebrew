require 'formula'

class Libshout < Formula
  homepage 'http://www.icecast.org/'
  url 'http://downloads.xiph.org/releases/libshout/libshout-2.3.1.tar.gz'
  sha1 '147c5670939727420d0e2ad6a20468e2c2db1e20'

  depends_on 'pkg-config' => :build
  depends_on 'libogg'
  depends_on 'libvorbis'

  depends_on 'theora' => :optional
  depends_on 'speex'  => :optional

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
