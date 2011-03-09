require 'formula'

class Libvorbis <Formula
  url 'http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.2.tar.bz2'
  md5 '798a4211221073c1409f26eac4567e8b'
  homepage 'http://vorbis.com'

  depends_on 'pkg-config' => :build
  depends_on 'libogg'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
