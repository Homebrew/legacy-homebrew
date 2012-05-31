require 'formula'

class Typespeed < Formula
  url 'http://downloads.sourceforge.net/project/typespeed/typespeed/0.6.5/typespeed-0.6.5.tar.gz'
  homepage 'http://typespeed.sourceforge.net'
  md5 '578102b418c7df84903d3e90df2e7483'

  def install
    # Fix the hardcoded gcc.
    inreplace 'src/Makefile.in', 'gcc', "#{ENV.cc}"
    inreplace 'testsuite/Makefile.in', 'gcc', "#{ENV.cc}"
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
