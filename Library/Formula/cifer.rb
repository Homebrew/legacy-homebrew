require 'formula'

class Cifer < Formula
  homepage 'http://code.google.com/p/cifer/'
  url 'http://cifer.googlecode.com/files/cifer-1.2.0.tar.gz'
  sha1 'dba2abbd672cd072c01f91a923e0830c009b66f2'

  def install
      system "make", "prefix=#{prefix}",
                     "CC=#{ENV.cc}",
                     "CFLAGS=#{ENV.cflags}",
                     "LDFLAGS=#{ENV.ldflags}",
                     "install"
  end
end
