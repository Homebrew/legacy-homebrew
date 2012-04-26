require 'formula'


class T1lib < Formula
  homepage 'http://www.t1lib.org'
  url 'http://sunsite.unc.edu/pub/Linux/libs/graphics/t1lib-5.1.2.tar.gz'
  md5 'a5629b56b93134377718009df1435f3c'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make without_doc"
    system "make install"
  end

  def test
    system "type1afm"
  end
end
