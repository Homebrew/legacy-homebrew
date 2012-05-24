require 'formula'

class Innotop < Formula
  url 'http://innotop.googlecode.com/files/innotop-1.8.1.tar.gz'
  homepage 'http://code.google.com/p/innotop/'
  md5 'af3e5c044912a9dfc7860d66a1a51bd4'

  depends_on 'DBD::mysql' => :perl

  def install
    system "perl", "Makefile.PL", "PREFIX=#{prefix}"
    system "make install"
  end
end
