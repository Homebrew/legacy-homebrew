require 'formula'

class Cconv < Formula
  homepage 'http://code.google.com/p/cconv/'
  url 'http://cconv.googlecode.com/files/cconv-0.6.2.tar.gz'
  md5 'f61de90861951d86f3d08e75603cd286'

  def patches
    # fix link with iconv: http://code.google.com/p/cconv/issues/detail?id=18
    "https://raw.github.com/gist/2585471/5adce03cc4245bd598828422f3f1279c39dfa281/gistfile1.txt"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
    rm "#{include}/unicode.h"
  end

end
