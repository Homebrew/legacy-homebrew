require 'formula'

class Innotop < Formula
  url 'http://innotop.googlecode.com/files/innotop-1.8.1.tar.gz'
  homepage 'http://code.google.com/p/innotop/'
  sha1 'a8d8deb5a40bca1890d24f355ae317254dfc4102'

  depends_on 'DBD::mysql' => :perl

  def install
    system "perl", "Makefile.PL", "PREFIX=#{prefix}"
    system "make install"
  end
end
