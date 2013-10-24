require 'formula'

class Algol68g < Formula
  homepage 'http://www.xs4all.nl/~jmvdveer/algol.html'
  url 'http://jmvdveer.home.xs4all.nl/algol68g-2.7.tar.gz'
  sha1 'b12f9ec9a70297f289b8e59c990788c08b11d759'

  depends_on 'gsl' => :optional

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/a68g", "--help"
  end
end
