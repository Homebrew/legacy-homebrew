require 'formula'

class Intercal < Formula
  homepage 'http://catb.org/esr/intercal/'
  url 'http://overload.intercal.org.uk/c/intercal-0.29.pax.gz'
  version '0.29'
  sha1 'a1109c97ab0a3ccc5ad181cb6d4b7aa470a69e1d'

  depends_on 'autoconf'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "convickt"
    system "ick"
  end
end
