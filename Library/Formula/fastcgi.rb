require 'formula'

class Fastcgi < Formula
  homepage 'http://www.fastcgi.com/'
  url 'http://www.fastcgi.com/dist/fcgi-2.4.0.tar.gz'
  md5 'd15060a813b91383a9f3c66faf84867e'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end

  def test
    system "cgi-fcgi"
    # Use otool to test if static & dynamic libraries are installed. otool returns 1 if lib not found
    system "otool -f /usr/local/lib/libfcgi++.0.0.0.dylib"
    system "otool -f /usr/local/lib/libfcgi++.0.dylib"
    system "otool -f /usr/local/lib/libfcgi++.dylib"
    system "otool -f /usr/local/lib/libfcgi++.a"
    system "otool -f /usr/local/lib/libfcgi++.la"
    system "otool -f /usr/local/lib/libfcgi.0.0.0.dylib"
    system "otool -f /usr/local/lib/libfcgi.0.dylib"
    system "otool -f /usr/local/lib/libfcgi.dylib"
    system "otool -f /usr/local/lib/libfcgi.a"
    system "otool -f /usr/local/lib/libfcgi.la"
    # Verify if headers are installed
    system "test -e /usr/local/include/fastcgi.h"
    system "test -e /usr/local/include/fastcgi.h"
    system "test -e /usr/local/include/fastcgi.h"
    system "test -e /usr/local/include/fcgi_stdi"
    system "test -e /usr/local/include/fcgiapp.h"
    system "test -e /usr/local/include/fcgimisc.h"
    system "test -e /usr/local/include/fcgio.h"
    system "test -e /usr/local/include/fcgios.h"
    system "test -e /usr/local/include/fcgi_config.h"
  end
end
