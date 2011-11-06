require 'formula'

class Innotop < Formula
  url 'http://innotop.googlecode.com/files/innotop-1.8.0.tar.gz'
  homepage 'http://code.google.com/p/innotop/'
  md5 '703ba1036bc1067650b558eecc3c15cd'

  depends_on 'DBD::mysql' => :perl

  def install
    system "perl Makefile.PL PREFIX=#{prefix}"
    system "make install"
  end
end
