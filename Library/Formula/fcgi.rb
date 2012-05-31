require 'formula'

class Fcgi < Formula
  url 'http://www.fastcgi.com/dist/fcgi-2.4.0.tar.gz'
  homepage 'http://www.fastcgi.com/'
  md5 'd15060a813b91383a9f3c66faf84867e'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
