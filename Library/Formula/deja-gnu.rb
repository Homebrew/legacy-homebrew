require 'formula'

class DejaGnu < Formula
  homepage 'http://www.gnu.org/software/dejagnu/'
  url 'http://ftpmirror.gnu.org/dejagnu/dejagnu-1.5.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/dejagnu/dejagnu-1.5.tar.gz'
  sha1 'bd84c71e0587af0278a9b6a404d6da1b92df66cd'
  head 'git://git.sv.gnu.org/dejagnu.git'

  def install
    ENV.j1 # Or fails on Mac Pro
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    # DejaGnu has no compiled code, so go directly to 'make check'
    system "make check"
    system "make install"
  end
end
