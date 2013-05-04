require 'formula'

class Ezstream < Formula
  homepage 'http://www.icecast.org/ezstream.php'
  url 'http://downloads.xiph.org/releases/ezstream/ezstream-0.5.6.tar.gz'
  sha1 'f9d3ee5a2f81d156685ffbfc59b556c63afcca83'

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
