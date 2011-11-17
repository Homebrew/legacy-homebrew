require 'formula'

class Xplanet < Formula
  url 'http://sourceforge.net/projects/xplanet/files/xplanet/1.2.2/xplanet-1.2.2.tar.gz'
  homepage 'http://xplanet.sourceforge.net/'
  md5 'b38c3b4cfdd772643f876a9bb15f288b'

  depends_on 'jpeg'
  depends_on 'giflib'
  depends_on 'libtiff'

  def install
    ENV.x11 # So we can see the system libpng
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
