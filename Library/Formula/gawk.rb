require 'formula'

class Gawk < Formula
  url 'http://ftpmirror.gnu.org/gawk/gawk-4.0.0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/gawk/gawk-4.0.0.tar.bz2'
  homepage 'http://www.gnu.org/software/gawk/'
  md5 '7cdc48e99b885a4bbe0e98dcf1706b22'

  fails_with_llvm "Undefined symbols when linking", :build => "2326"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    ENV.j1 # Run tests serialized
    system "make check"
    system "make install"
  end
end
