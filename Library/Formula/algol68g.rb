require 'formula'

class Algol68g < Formula
  homepage 'http://www.xs4all.nl/~jmvdveer/algol.html'
  url 'http://jmvdveer.home.xs4all.nl/algol68g-2.6.tar.gz'
  sha1 'a054de1a74b84adec43ea1db4cd8ac0798e0fd3e'

  depends_on 'gsl' => :optional

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/a68g", "--help"
  end
end
