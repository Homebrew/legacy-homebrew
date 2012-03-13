require 'formula'

class Picoc < Formula
  homepage 'http://code.google.com/p/picoc/'
  url 'http://picoc.googlecode.com/files/picoc-2.1.tar.bz2'
  md5 '6505fb108d195bad0854c7024993cc24'

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags} -DUNIX_HOST"
    bin.install "picoc"
  end
end
