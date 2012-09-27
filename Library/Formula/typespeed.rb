require 'formula'

class Typespeed < Formula
  url 'http://downloads.sourceforge.net/project/typespeed/typespeed/0.6.5/typespeed-0.6.5.tar.gz'
  homepage 'http://typespeed.sourceforge.net'
  sha1 'b44be835404b840ba6d5408b42868d0af454d57d'

  def install
    # Fix the hardcoded gcc.
    inreplace 'src/Makefile.in', 'gcc', ENV.cc
    inreplace 'testsuite/Makefile.in', 'gcc', ENV.cc
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
