require 'formula'

class Xplanet < Formula
  homepage 'http://xplanet.sourceforge.net/'
  url 'http://sourceforge.net/projects/xplanet/files/xplanet/1.2.2/xplanet-1.2.2.tar.gz'
  md5 'b38c3b4cfdd772643f876a9bb15f288b'

  depends_on 'pkg-config' => :build
  depends_on 'jpeg'
  depends_on 'giflib'
  depends_on 'libtiff'

  def install
    ENV.x11
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-x"
    system "make install"
  end
end
