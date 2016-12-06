require 'formula'

class Libpng12 < Formula
  url 'ftp://ftp.simplesystems.org/pub/libpng/png/src/libpng-1.2.46.tar.gz'
  homepage 'http://www.libpng.org/pub/png/'
  md5 '03ddfc17ad321db93f984581e9415d22'

  keg_only "OS X provided. This Formula is here to be able to compile the venerable Gimp."

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
