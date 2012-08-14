require 'formula'

class Ezstream < Formula
  url 'http://downloads.xiph.org/releases/ezstream/ezstream-0.5.6.tar.gz'
  homepage 'http://www.icecast.org/ezstream.php'
  md5 '1be68119d44fbe71454a901fa650a359'

  depends_on 'libvorbis'
  depends_on 'libshout'
  depends_on 'theora'
  depends_on 'speex'
  depends_on 'libogg'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
