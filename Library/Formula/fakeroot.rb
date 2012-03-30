require 'formula'

class Fakeroot < Formula
  homepage 'http://mackyle.github.com/fakeroot/'
  url 'https://github.com/mackyle/fakeroot/tarball/1f42602a60deb702f276732b478fb5ce695d82d8'
  md5 '5fd8f5958c6aff3d10b0eae0d95c8698'

  def install
    system "./bootstrap"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--disable-static", "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "fakeroot -v"
  end
end
