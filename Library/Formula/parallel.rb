require 'formula'

class Parallel < Formula
  homepage 'http://savannah.gnu.org/projects/parallel/'
  url 'http://ftpmirror.gnu.org/parallel/parallel-20120222.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/parallel/parallel-20120222.tar.bz2'
  md5 '31f211087c7f1c7b99092f6bccaa65ed'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
