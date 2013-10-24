require 'formula'

class Timidity < Formula
  homepage 'http://timidity.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/timidity/TiMidity++/TiMidity++-2.14.0/TiMidity++-2.14.0.tar.bz2'
  sha1 '3d1d18ddf3e52412985af9a49dbe7ad345b478a8'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "#{bin}/timidity"
  end
end
