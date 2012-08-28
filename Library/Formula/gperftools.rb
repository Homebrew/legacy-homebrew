require 'formula'

class Gperftools < Formula
  homepage 'http://code.google.com/p/gperftools/'
  url 'http://gperftools.googlecode.com/files/gperftools-2.0.tar.gz'
  md5 '13f6e8961bc6a26749783137995786b6'

  def install
    ENV.append_to_cflags '-D_XOPEN_SOURCE'
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
