require 'formula'

class Conserver < Formula
  url 'http://conserver.com/conserver-8.1.18.tar.gz'
  homepage 'http://conserver.com'
  md5 '93d1c38df71b4e3fd5d8f7ad6fc186bb'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
