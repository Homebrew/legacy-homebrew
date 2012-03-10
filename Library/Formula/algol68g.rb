require 'formula'

class Algol68g < Formula
  homepage 'http://www.xs4all.nl/~jmvdveer/algol.html'
  url 'http://jmvdveer.home.xs4all.nl/algol68g-2.3.7.tar.gz'
  md5 '8a1c2f169b7aaa9d9155b42b6b5a12bf'

  depends_on 'gsl' => :optional

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/a68g", "--help"
  end
end
