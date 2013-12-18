require 'formula'

class Innotop < Formula
  homepage 'http://code.google.com/p/innotop/'
  url 'http://innotop.googlecode.com/files/innotop-1.9.1.tar.gz'
  sha1 '6b0b5f492e7188152727f6c157043be180ba516a'

  depends_on 'DBD::mysql' => :perl
  depends_on 'Term::ReadKey' => :perl

  def install
    system "perl", "Makefile.PL", "PREFIX=#{prefix}"
    system "make install"
  end
end
