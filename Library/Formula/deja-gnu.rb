require 'formula'

class DejaGnu < Formula
  url 'http://ftpmirror.gnu.org/dejagnu/dejagnu-1.5.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/dejagnu/dejagnu-1.5.tar.gz'
  homepage 'http://www.gnu.org/software/dejagnu/'
  md5 '3df1cbca885e751e22d3ebd1ac64dc3c'
  head 'git://git.sv.gnu.org/dejagnu.git'

  def install
    ENV.j1 # Or fails on Mac Pro
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    # DejaGnu has no compiled code, so go directly to 'make check'
    system "make check"
    system "make install"
  end
end
