require 'formula'

class Typespeed < Formula
  homepage 'http://typespeed.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/typespeed/typespeed/0.6.5/typespeed-0.6.5.tar.gz'
  sha1 'b44be835404b840ba6d5408b42868d0af454d57d'

  def install
    # Fix the hardcoded gcc.
    inreplace 'src/Makefile.in', 'gcc', ENV.cc
    inreplace 'testsuite/Makefile.in', 'gcc', ENV.cc
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
