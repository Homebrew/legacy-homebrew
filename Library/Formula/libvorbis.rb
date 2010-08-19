require 'formula'

class Libvorbis <Formula
  url 'http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.1.tar.bz2'
  md5 '90b1eb86e6d57694ffdfc2e4d8c7a64e'
  homepage 'http://vorbis.com'

  depends_on 'pkg-config'
  depends_on 'libogg'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
