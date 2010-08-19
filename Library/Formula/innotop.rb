require 'formula'

class Innotop <Formula
  url 'http://innotop.googlecode.com/files/innotop-1.7.2.tar.gz'
  homepage 'http://code.google.com/p/innotop/'
  md5 '37d8c71fb1eefbc607a733dd4b38af05'

  depends_on 'DBD::mysql' => :perl

  def install
    system "perl Makefile.PL PREFIX=#{prefix}"
    system "make install"
  end
end
