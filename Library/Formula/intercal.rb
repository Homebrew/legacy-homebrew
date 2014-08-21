require 'formula'

class Intercal < Formula
  homepage 'http://catb.org/~esr/intercal/'
  url 'http://catb.org/~esr/intercal/intercal-0.29.tar.gz'
  sha1 '6f496b158e5f9dbf05a81c5e75f2d61698e65b15'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "#{bin}/convickt"
    system "#{bin}/ick"
  end
end
