require 'formula'

class Cppunit < Formula
  url 'http://downloads.sourceforge.net/project/cppunit/cppunit/1.12.1/cppunit-1.12.1.tar.gz'
  homepage 'http://sourceforge.net/apps/mediawiki/cppunit/'
  md5 'bd30e9cf5523cdfc019b94f5e1d7fd19'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
