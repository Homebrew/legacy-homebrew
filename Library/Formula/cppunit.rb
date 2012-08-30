require 'formula'

class Cppunit < Formula
  homepage 'http://sourceforge.net/apps/mediawiki/cppunit/'
  url 'http://downloads.sourceforge.net/project/cppunit/cppunit/1.12.1/cppunit-1.12.1.tar.gz'
  sha1 'f1ab8986af7a1ffa6760f4bacf5622924639bf4a'

  option :universal

  def install
    ENV.universal_binary if build.universal?

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
