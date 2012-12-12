require 'formula'

class Innotop < Formula
  homepage 'http://code.google.com/p/innotop/'
  url 'http://innotop.googlecode.com/files/innotop-1.9.0.tar.gz'
  sha1 '4f8cbf6d01a1723a5c450d66e192610c5b28c4d7'

  depends_on 'DBD::mysql' => :perl

  def install
    system "perl", "Makefile.PL", "PREFIX=#{prefix}"
    system "make install"
  end
end
